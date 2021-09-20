class DashboardsController < ApplicationController

  def show
    authorize(:dashboard, :show?)
    @admins = User.where(admin: true)
    @non_admins = User.where(admin:false)
    @non_validated_coachs = User.where(coach: true).where(validated_coach: false)
    @coachs = User.where(coach: true).where(validated_coach: true)
    @locations = Location.all
    @partners = Partner.all
  end

  def analytics
    authorize(:dashboard, :analytics?)
    @users = User.where(coach: false).group_by_month.count
    @coachs = User.where(coach: true).group_by_month.count
    @bookings = Booking.where(used_credit: false).group_by{ |u| u.lesson.date.beginning_of_month }
    @bookings_credit = Booking.where(used_credit: true).group_by{ |u| u.lesson.date.beginning_of_month }
  end
end
