class LocationPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    user.admin?
  end

  def destroy?
    user.admin?
  end
end
