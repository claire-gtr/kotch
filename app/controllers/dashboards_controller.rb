class DashboardsController < ApplicationController

  def show
    authorize(:dashboard, :show?)
    @admins = User.where(admin: true)
    @non_admins = User.where(admin:false)
    @locations = Location.all
  end
end
