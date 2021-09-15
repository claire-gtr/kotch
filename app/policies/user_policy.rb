class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def profile?
    record == user || user.admin
  end

  def become_admin?
    user.admin?
  end

  def undo_admin?
    user.admin?
  end

  def coach_validation?
    user.admin?
  end

  def sportive_profile?
    coachs = []
    record.bookings.each do |booking|
      coachs << booking.lesson.user
    end
    coachs.include?(user)
  end
end
