class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :lesson
  has_many :messages

  validates :user, uniqueness: { scope: :lesson }

  scope :group_by_month, -> { group("date_trunc('month', date_lesson) ") }
  scope :by_lesson_status, ->(val) { joins(:lesson).merge(Lesson.by_status(val)) }
  scope :future_lessons, -> { joins(:lesson).merge(Lesson.futures) }
  scope :next_week, -> { joins(:lesson).merge(Lesson.next_week) }
  scope :no_invitation, -> { where.not(status: 'Invitation envoyée') }
  scope :not_lesson_canceled, -> { joins(:lesson).merge(Lesson.not_canceled) }
  scope :order_lesson_date_asc, -> { joins(:lesson).merge(Lesson.order('date ASC')) }
  scope :by_lesson_date, ->(val) { joins(:lesson).merge(Lesson.by_date(val)) }
  scope :by_lesson_start_end, ->(val) { joins(:lesson).merge(Lesson.by_start_end(val)) }
  scope :by_lesson_activity, ->(val) { joins(:lesson).merge(Lesson.by_activity(val)) }

  def date_lesson
    self.lesson.date
  end
end
