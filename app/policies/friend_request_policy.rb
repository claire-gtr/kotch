class FriendRequestPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    if user.coach?
      false
    else
      true
    end
  end

  def update?
    if user.coach?
      false
    else
      true
    end
  end
end
