class BookingPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(user: user)
    end
  end

  def create?
    true
  end

  def accept_invitation?
    true
  end

  def public_lesson_booking?
    true
  end
end
