class Message < ApplicationRecord
  belongs_to :booking, optional: true
  belongs_to :lesson
  validates :content, presence: true
end
