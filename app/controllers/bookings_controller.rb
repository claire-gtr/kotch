class BookingsController < ApplicationController

  def create
    @booking = Booking.new(booking_params)
    @booking.status = "Invitation envoyée"
    @user = @booking.user
    authorize @booking
    if @booking.save
      mail = BookingMailer.with(user: @user, booking: @booking).invitation
      mail.deliver_now
      redirect_to lessons_path
    else
      @bookings = Booking.where(user: current_user)
      @booking = Booking.new
      @lessons = Lesson.where(user: current_user).where("date >= ?", Time.now).order('date DESC')
      @message = Message.new
      @friends = current_user.my_friends
      render "lessons/index"
    end
  end

  def accept_invitation
    @booking = Booking.find(params[:booking_id])
    authorize @booking
    @lesson = @booking.lesson
    has_credit = current_user.has_credit(@lesson.date)
    if has_credit[:has_credit] == true
      @booking.status = "Confirmé"
      if has_credit[:origin] == 'credit'
        @booking.used_credit = true
      end
      @booking.save
      if @lesson.bookings.where(status: "Confirmé").count == 5 && @booking.lesson.user.nil?
        User.where(coach: true).each do |user|
          mail = BookingMailer.with(lesson: @lesson, user: user).invite_coachs
          mail.deliver_now
        end
      end
      flash[:info] = "Vous êtes bien inscrit(e) à la séance"
      redirect_to lessons_path
    else
      flash[:alert] = "Vous n'avez pas de séance pour réserver une séance ce mois-ci.."
      redirect_to offers_path
    end
  end

  def public_lesson_booking
    @lesson = Lesson.find(params[:lesson_id])
    has_credit = current_user.has_credit(@lesson.date)
    @booking = Booking.new
    authorize @booking

    if @lesson.bookings.where(user: current_user).any?
      authorize(:booking, :public_lesson_booking?)
      flash[:alert] = "Vous avez déjà une réservation pour cette séance."
      redirect_to public_lessons_path
    elsif !current_user.coach
      if has_credit[:has_credit] == true
        @booking.lesson = @lesson
        @booking.status = "Confirmé"
        @booking.user = current_user
        if has_credit[:origin] == 'credit'
          @booking.used_credit = true
        end
        @booking.save
        if @lesson.bookings.where(status: "Confirmé").count == 5 && @booking.lesson.user.nil?
          User.where(coach: true).each do |user|
            mail = BookingMailer.with(lesson: @lesson, user: user).invite_coachs
            mail.deliver_now
          end
        end
        if @lesson.bookings.where(status: "Confirmé").count == 5 && !@booking.lesson.user.nil?
          send_confirmation_email_to_coach
        end
        flash[:info] = "Vous êtes bien inscrit(e) à la séance"
        redirect_to lessons_path
      else
        flash[:alert] = "Vous n'avez pas de séance pour réserver une séance ce mois-ci.."
        redirect_to offers_path
      end
    end
  end

  def destroy
    @booking = Booking.find(params[:id])
    @booking.user.update(credit_count: @booking.user.credit_count + 1) if @booking.used_credit
    authorize @booking
    @booking.destroy
    redirect_to lessons_path
  end

  private

  def send_confirmation_email_to_coach
    mail = BookingMailer.with(user: @lesson.user, lesson: @lesson).confirmation_email_to_coach
    mail.deliver_now
  end

  def booking_params
    params.require(:booking).permit(:user_id, :lesson_id)
  end
end
