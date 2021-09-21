class Lesson < ApplicationRecord
  SPORTS = ["Cross Training", "Cuisses Abdos Fessiers", "Fit Boxing", "HIIT", "Pilate", "Renforcement musculaire", "Stretching", "Yoga" ]
  belongs_to :user, optional: true
  belongs_to :location
  has_many :bookings
  has_many :users, through: :bookings
  has_many :messages
  validates :sport_type, inclusion: {in: SPORTS}
  validates :date, presence: true
  scope :group_by_month,   -> { group("date_trunc('month', date) ") }

  def diff_time
    (self.date.to_time - 24.hours).to_datetime
  end
end
