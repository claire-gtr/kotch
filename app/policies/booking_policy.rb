class BookingPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(user: user)
    end
  end

  def create?
    true
  end

  def create_by_emails?
    true
  end

  def accept_invitation?
    true
  end

  def public_lesson_booking?
    true
  end

  def enterprise_lesson_booking?
    user.person? && user.enterprise.present?
  end

  def destroy?
    record.user == user
  end
end
