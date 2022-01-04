class EmploymentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    user_loggedin? && user.person?
  end

  def update?
    user_loggedin? && (record.enterprise == user)
  end
end
