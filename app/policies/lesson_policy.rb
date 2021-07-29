class LessonPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(user: user)
    end
  end

  def create?
    true
  end

  def change_lesson_public?
    true
  end

  def public_lessons?
    true
  end

  def be_coach?
    user.coach
  end
end
