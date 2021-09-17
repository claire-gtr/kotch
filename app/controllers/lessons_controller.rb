class LessonsController < ApplicationController

  def index
    @lessons = policy_scope(Lesson)
    @lessons = @lessons.where.not(status: 'canceled').order('date DESC')
    @message = Message.new
    @friends = current_user.my_friends
    @booking = Booking.new
    @pending_invitations = Booking.where(status: "invitation send", user: current_user)

  end

  def new
    @lesson = Lesson.new
    @friends = current_user.my_friends
    authorize @lesson
    if current_user.coach && !current_user.validated_coach
      flash[:alert] = "Un administrateur doit valider votre compte coach."
      redirect_to root_path
    else
      @locations = Location.all
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
          friend_ids= params[:friends]
          friend_ids.each do |id|
            user = User.find(id.to_i)
            booking = Booking.new(user: user, lesson: @lesson)
            booking.status = "invitation send"
            booking.save
            mail = BookingMailer.with(user: user, booking: booking).invitation
            mail.deliver_now
          end
        else
          flash[:alert] = "Vous n'avez pas de séance pour réserver une séance ce mois-ci.."
          redirect_to offers_path
        end
      end
    end
  end

  def cancel
    @lesson = Lesson.find(params[:id])
    authorize @lesson
    @lesson.bookings.each do |b|
      if b.used_credit
        b.user.update(credit_count: b.user.credit_count + 1)
      end
      b.destroy
    end
    @lesson.update(status: 'canceled')
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
    elsif current_user.coach
      @lessons_in_future = Lesson.where(public: true).where("date >= ?", Time.now).where.not(status: 'canceled').order('date DESC')
      @lessons = []
      @lessons_in_future.each do |lesson|
        if lesson.bookings.where(status: "confirmé").count >= 5
          @lessons << lesson
        end
      end
    else
      if params[:day].present?
        @lessons = Lesson.where("DATE_PART('dow', date)=?", params[:day]).where(public: true).where("date >= ?", Time.now).where.not(status: 'canceled').order('date DESC')
      else
        @lessons = Lesson.where(public: true).where("date >= ?", Time.now).where.not(status: 'canceled').order('date DESC')
      end
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
        @lesson.status = "validée"
        @lesson.save
        flash[:notice] = "Vous êtes désormais le coach de cette séance."
        send_email_to_users
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
        send_email_to_users
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

  def focus_lesson
    @lesson = Lesson.find(params[:id])
    @lesson.update(lesson_params)
    authorize @lesson
    @lesson.save
    redirect_to profile_path
  end

  private

  def send_email_to_users
    @lesson.bookings.where(status: "confirmé").each do |booking|
      mail = BookingMailer.with(user: booking.user, booking: booking, lesson: @lesson).coach_confirmed
      mail.deliver_now
    end
  end

  def lesson_params
    params.require(:lesson).permit(:date, :location_id, :sport_type, :focus)
  end
end
