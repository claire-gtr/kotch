class LocationsController < ApplicationController

  def create
    @location = Location.new(location_params)
    @location.user = current_user
    authorize @location
    if @location.save
      redirect_to dashboard_path
    else
      render 'dashboard/show'
    end
  end

  private

  def location_params
    params.require(:location).permit(:name)
  end
end
