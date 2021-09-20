class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :lesson
  has_many :messages
  validates :user, uniqueness: { scope: :lesson }
  scope :group_by_month,   -> { group("date_trunc('month', date_lesson) ") }

  def date_lesson
    self.lesson.date
  end
end
