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
end
