class LessonsController < ApplicationController

  def new
    @lesson = Lesson.new
    authorize @lesson
    @locations = Location.all

    # the `geocoded` scope filters only flats with coordinates (latitude & longitude)
    @markers = @locations.geocoded.map do |location|
      {
        lat: location.latitude,
        lng: location.longitude,
        info_window: render_to_string(partial: "info_window", locals: { location: location })
      }
    end
  end

  def create
    @lesson = Lesson.new(lesson_params)
    authorize @lesson
    if @lesson.save
      @booking = Booking.new
      @booking.user = current_user
      @booking.lesson = @lesson
      @booking.status = "confirmé"
      @booking.save
      redirect_to profile_path
    else
      render :new
    end
  end

  private

  def lesson_params
    params.require(:lesson).permit(:date, :location_id, :sport_type)
  end
end
