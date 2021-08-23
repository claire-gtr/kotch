class LessonPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(user: user).where("date >= ?", Time.now)
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

  def be_coach_via_mail?
    true
  end
end
