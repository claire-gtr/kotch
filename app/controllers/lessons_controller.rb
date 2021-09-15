class LessonsController < ApplicationController

  def index
    @lessons = policy_scope(Lesson)
    @lessons = @lessons.order('date DESC')
    @message = Message.new
    @friends = current_user.my_friends
    @booking = Booking.new
    @pending_invitations = Booking.where(status: "invitation send", user: current_user)

  end

  def new
    @lesson = Lesson.new
    authorize @lesson
    if current_user.coach && !current_user.validated_coach
      flash[:alert] = "Un administrateur doit valider votre compte coach."
      redirect_to root_path
    else
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
  end

  def create
    if current_user.coach && !current_user.validated_coach
      flash[:alert] = "Un administrateur doit valider votre compte coach."
      redirect_to root_path
    else
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
        has_credit = current_user.has_credit(@lesson.date)
        if has_credit[:has_credit] == true
          @booking = Booking.new
          @booking.user = current_user
          @booking.lesson = @lesson
          @booking.status = "confirmé"
          if has_credit[:origin] == 'credit'
            @booking.used_credit = true
          end
          @booking.save
          if @lesson.save
            redirect_to profile_path
          else
            render :new
          end
        else
          flash[:alert] = "Vous n'avez pas de crédit pour réserver une leçon ce mois-ci."
          redirect_to offers_path
        end
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
    authorize(:lesson, :public_lessons?)
    if current_user.coach && !current_user.validated_coach
      flash[:alert] = "Un administrateur doit valider votre compte coach."
      redirect_to root_path
    else
      @lessons = Lesson.where(public: true).where("date >= ?", Time.now).order('date DESC')#.where("date >= ?", Time.now)
    end
  end

  def be_coach
    if current_user.coach && !current_user.validated_coach
      flash[:alert] = "Un administrateur doit valider votre compte coach."
      redirect_to root_path
    else
      @lesson = Lesson.find(params[:id])
      authorize @lesson
      if @lesson.user.nil?
        @lesson.user = current_user
        @lesson.save
        flash[:notice] = "Vous êtes désormais le coach de cette séance."
        redirect_to profile_path
      else
        flash[:alert] = "Un coach s'est déjà positionné sur cette séance."
        redirect_to public_lessons_path
      end
    end
  end

  def be_coach_via_mail
    if current_user.coach && !current_user.validated_coach
      flash[:alert] = "Un administrateur doit valider votre compte coach."
      redirect_to root_path
    else
      @lesson = Lesson.find(params[:lesson_id])
      @user = User.find(params[:user_id])
      authorize @lesson
      if @lesson.user.nil?
        @lesson.user = @user
        @lesson.status = "validée"
        @lesson.save
        flash[:notice] = "Vous êtes désormais le coach de cette séance."
        redirect_to profile_path
      else
        flash[:alert] = "Un coach s'est déjà positionné sur cette séance."
        redirect_to public_lessons_path
      end
    end
  end

  def lesson_done
    @lesson = Lesson.find(params[:id])
    @lesson.status = "effectuée"
    authorize @lesson
    @lesson.save
    redirect_to profile_path
  end
  def lesson_not_done
    @lesson = Lesson.find(params[:id])
    @lesson.status = "non effectuée"
    authorize @lesson
    @lesson.save
    redirect_to profile_path
  end

  private

  def lesson_params
    params.require(:lesson).permit(:date, :location_id, :sport_type)
  end
end
