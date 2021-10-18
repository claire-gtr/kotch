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

  def export_number_of_users?
    user.admin?
  end

  def export_number_of_coachs?
    user.admin?
  end

  def export_lessons_sub?
    user.admin?
  end

  def export_lessons_credit?
    user.admin?
  end

  def export_filling_rate?
    user.admin?
  end

  def all_lessons?
    user.admin?
  end
end
