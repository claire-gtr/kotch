class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :lesson
  has_many :messages
  validates :user, uniqueness: { scope: :lesson }
end
