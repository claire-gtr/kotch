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
    show?
  end

  def export_number_of_users?
    show?
  end

  def export_number_of_coachs?
    show?
  end

  def export_lessons_sub?
    show?
  end

  def export_lessons_credit?
    show?
  end

  def export_filling_rate?
    show?
  end

  def export_lessons_done_this_year?
    show?
  end

  def export_company_discovers?
    show?
  end

  def export_users_data?
    show?
  end

  def all_lessons?
    show?
  end
end
