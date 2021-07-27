class Message < ApplicationRecord
  belongs_to :booking
  belongs_to :lesson
  validates :content, presence: true
end
