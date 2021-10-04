class LocationsController < ApplicationController
  def create
    @location = Location.new(location_params)
    @location.user = current_user
    authorize @location
    if @location.save
      redirect_to dashboard_path
    else
      redirect_back fallback_location: dashboard_path, alert: 'Erreur de saisie.'
      # render 'dashboard/show'
    end
  end

  def destroy
    @location = Location.find(params[:id])
    authorize @location
    @location.destroy
    redirect_to dashboard_path
  end

  private

  def location_params
    params.require(:location).permit(:name)
  end
end
