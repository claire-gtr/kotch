class LocationsController < ApplicationController
  def create
    @location = Location.new(location_params)
    @location.user = current_user
    @location.visible = true
    authorize @location
    if @location.save
      redirect_to dashboard_path, notice: 'Le lieu a bien été enregistré.'
    else
      redirect_back fallback_location: dashboard_path, alert: 'Erreur de saisie.'
      # render 'dashboard/show'
    end
  end

  def destroy
    @location = Location.find(params[:id])
    authorize @location
    @lessons_with_this_location = Lesson.where(location_id: @location.id)
    if @lessons_with_this_location.count == 0
      @location.destroy
      redirect_to dashboard_path, notice: 'Le lieu a bien été supprimé.'
    else
      redirect_to dashboard_path, alert: 'Le lieu ne peut pas être supprimé, car il est déjà utilisé pour une séance.'
    end
  end

  private

  def location_params
    params.require(:location).permit(:name)
  end
end
