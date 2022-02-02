class Lesson < ApplicationRecord
  SPORTS = ["Cross Training", "Cuisses Abdos Fessiers", "Fit Boxing", "HIIT", "Pilate", "Renforcement musculaire", "Running", "Stretching", "Yoga" ]
  belongs_to :user, optional: true
  belongs_to :location
  has_many :bookings
  has_many :users, through: :bookings
  has_many :messages
  has_many :waiting_bookings

  enum reccurency: { not_reccurent: 0, weekly: 1 }

  validates :sport_type, inclusion: { in: SPORTS }
  validates :date, presence: true
  validates :reccurency, inclusion: { in: reccurencies.keys }, presence: true

  scope :group_by_month, -> { group("date_trunc('month', date) ") }
  scope :by_status, ->(val) { where(status: val) }
  scope :futures, -> { where('date >= ?', DateTime.now) }
  scope :next_24h, -> { where(date: DateTime.now..DateTime.now + 1.day) }
  scope :next_week, -> { where(date: DateTime.now.next_week..DateTime.now.next_week.end_of_week) }
  scope :not_canceled, -> { where.not(status: 'canceled') }
  scope :by_date, ->(val) { where("DATE_PART('dow', date)=?", val) }
  scope :by_start_end, ->(val) { where('EXTRACT(hour FROM date) BETWEEN ? AND ?', val[0], val[1]) }
  scope :by_activity, ->(val) { where(sport_type: val) }

  after_create :invite_coach_for_enterprise

  def diff_time
    (self.date.to_time - 24.hours).to_datetime
  end

  def enterprise?
    creator = self.bookings&.first&.user
    return creator.present? && creator.enterprise?
  end

  def creator
    return bookings&.first&.user
  end

  def enterprise
    return unless creator.present? && creator.enterprise?

    return creator
  end

  private

  def invite_coach_for_enterprise
    return unless status == 'Pre-validée'

    User.where(coach: true).each do |user|
      mail = BookingMailer.with(lesson: self, user: user).invite_coachs_enterprise
      mail.deliver_now
    end
  end
end
