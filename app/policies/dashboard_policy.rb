class DashboardPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    user.admin?
  end

  def analytics?
    user.admin?
  end

  def all_lessons?
    user.admin?
  end
end
