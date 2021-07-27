class Lesson < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :location
  has_many :bookings
  has_many :users, through: :bookings
  has_many :messages
end
