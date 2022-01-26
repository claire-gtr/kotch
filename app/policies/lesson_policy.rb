class LessonPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.coach? && user.validated_coach?
        scope.where(user: user).where("date >= ?", Time.now)
      elsif !user.coach? || user.enterprise?
        ids = []
        user.bookings.each do |booking|
          unless booking.status == "Invitation envoyée"
            ids << booking.lesson_id
          end
        end
        scope.where(id: ids).where("date >= ?", Time.now)
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
    if (record.user == user) || (record.creator == user)
      true
    else
      false
    end
  end

  def change_lesson_public?
    !record.enterprise?
  end

  def public_lessons?
    true
  end

  def be_coach?
    user.coach?
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

  def pre_validate_lesson?
    user.admin?
  end

  def invite_enterprise_employees?
    record.enterprise? && (record.creator == user)
  end

  def employee_enterprise_lessons?
    user.person? && user.employee_employments.find_by(accepted: true).present?
  end
end
