class EnterprisePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def sign_up?
    true
  end
end
