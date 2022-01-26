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
  scope :next_week, -> { where(date: DateTime.now.next_week..DateTime.now.next_week.end_of_week) }

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

  # def enterprise_has_credit?
  #   return unless status == 'Pre-validée'

  #   enterprise.has_credit(self.date)[:has_credit] == true
  # end

  private

  def invite_coach_for_enterprise
    return unless status == 'Pre-validée'

    User.where(coach: true).each do |user|
      mail = BookingMailer.with(lesson: self, user: user).invite_coachs_enterprise
      mail.deliver_now
    end
  end
end
