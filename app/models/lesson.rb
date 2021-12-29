class Lesson < ApplicationRecord
  SPORTS = ["Cross Training", "Cuisses Abdos Fessiers", "Fit Boxing", "HIIT", "Pilate", "Renforcement musculaire", "Stretching", "Yoga" ]
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

  after_create :set_reccurency_lessons, if: :enterprise_has_credit?, unless: :not_reccurent?

  def diff_time
    (self.date.to_time - 24.hours).to_datetime
  end

  def enterprise?
    creator = self.bookings&.first&.user
    return creator.present? && creator.enterprise?
  end

  def enterprise
    creator = self.bookings&.first&.user
    return unless creator.present? && creator.enterprise?

    return creator
  end

  def enterprise_has_credit?
    return unless enterprise?

    enterprise.has_credit(self.date)[:has_credit] == true
  end

  private

  def set_reccurency_lessons
    return if not_reccurent? || enterprise?

    if weekly?
      3.times do |i|
        new_lesson = self.dup
        new_lesson.date = self.date + ((i + 1) * 7).days
        new_lesson.reccurency = :not_reccurent
        new_lesson.save
        new_booking = self.bookings.first.dup
        new_booking.lesson = new_lesson
        new_booking.save
      end
    end
  end
end
