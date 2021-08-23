class Lesson < ApplicationRecord
  SPORTS = ["Yoga", "Pilate", "Stretching", "HIIT", "Cross Training", "Fit Boxing", "Cuisses Abdos Fessiers", "Renforcement musculaire" ]
  belongs_to :user, optional: true
  belongs_to :location
  has_many :bookings
  has_many :users, through: :bookings
  has_many :messages
  validates :sport_type, inclusion: {in: SPORTS}
end
