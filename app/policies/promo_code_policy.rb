class PromoCodePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    user.admin?
  end

  def toggle_active_status?
    user.admin?
  end
end
