class LessonsController < ApplicationController

  def index
    @lessons = policy_scope(Lesson)
    @lessons = @lessons.order('date DESC')
    @message = Message.new
    @friends = current_user.my_friends
    @booking = Booking.new

  end

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
    if current_user.coach
      @lesson.public = true
      @lesson.user = current_user
      if @lesson.save
        redirect_to profile_path
      else
        render :new
      end
    else
      @booking = Booking.new
      @booking.user = current_user
      @booking.lesson = @lesson
      @booking.status = "confirmé"
      @booking.save
      if @lesson.save
        redirect_to profile_path
      else
        render :new
      end
    end
  end

  def change_lesson_public
    @lesson = Lesson.find(params[:id])
    authorize @lesson
    @lesson.public = true
    @lesson.save
    redirect_to lessons_path
  end

  def public_lessons
    @lessons = Lesson.where(public: true).where("date >= ?", Time.now).order('date DESC')#.where("date >= ?", Time.now)
    # if current_user.coach
    #   @lessons = []
    #   Lesson.all.each do |lesson|
    #     if lesson.bookings.any? && lesson.bookings.where(status: "confirmé").count >= 5
    #       @lessons << lesson
    #     end
    #   end
    # else
    # end
    authorize(:lesson, :public_lessons?)
  end

  def be_coach
    @lesson = Lesson.find(params[:id])
    authorize @lesson
    if @lesson.user.nil?
      @lesson.user = current_user
      @lesson.save
      # MAIL AUX PARTICIPANTS
      flash[:notice] = "Vous êtes désormais le coach de cette séance."
      redirect_to profile_path
    else
      flash[:alert] = "Un coach s'est déjà positionné sur cette séance."
      redirect_to public_lessons_path
    end
  end

  def be_coach_via_mail
    @lesson = Lesson.find(params[:lesson_id])
    @user = User.find(params[:user_id])
    authorize @lesson
    if @lesson.user.nil?
      @lesson.user = @user
      @lesson.save
      # MAIL AUX PARTICIPANTS
      flash[:notice] = "Vous êtes désormais le coach de cette séance."
      redirect_to profile_path
    else
      flash[:alert] = "Un coach s'est déjà positionné sur cette séance."
      redirect_to public_lessons_path
    end
  end

  private

  def lesson_params
    params.require(:lesson).permit(:date, :location_id, :sport_type)
  end
end
