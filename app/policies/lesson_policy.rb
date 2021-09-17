class LessonPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.coach && user.validated_coach
        scope.where(user: user).where("date >= ?", Time.now)
      elsif !user.coach
        ids = []
        user.bookings.each do |booking|
          unless booking.status == "Invitation envoyée"
            ids << booking.lesson_id
          end
        end
        scope.where(id: ids)
      else
        raise Pundit::NotAuthorizedError
      end
    end
  end

  def create?
    if (user.coach && !user.validated_coach)
      false
    else
      true
    end
  end

  def cancel?
    if record.user == user
      true
    else
      false
    end
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
  def lesson_done?
    record.user == user
  end

  def lesson_not_done?
    record.user == user
  end

  def focus_lesson?
    true
  end
end
