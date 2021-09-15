class BookingsController < ApplicationController

  def create
    @booking = Booking.new(booking_params)
    @booking.status = "invitation send"
    @user = @booking.user
    authorize @booking
    if @booking.save
      mail = BookingMailer.with(user: @user, booking: @booking).invitation
      mail.deliver_now
      redirect_to lessons_path
    else
      @bookings = Booking.where(user: current_user)
      @booking = Booking.new
      render :index
    end
  end

  def accept_invitation
    @booking = Booking.find(params[:booking_id])
    authorize @booking
    @lesson = @booking.lesson
    has_credit = current_user.has_credit(@lesson.date)
    if has_credit[:has_credit] == true
      @booking.status = "confirmé"
      if has_credit[:origin] == 'credit'
        @booking.used_credit = true
      end
      @booking.save
      if @lesson.bookings.where(status: "confirmé").count == 2 && @booking.lesson.user.nil?
        User.where(coach: true).each do |user|
          mail = BookingMailer.with(lesson: @lesson, user: user).invite_coachs
          mail.deliver_now
        end
      end
      flash[:info] = "Vous êtes bien inscrit(e) à la séance"
      redirect_to lessons_path
    else
      flash[:alert] = "Vous n'avez pas de crédit pour réserver une leçon ce mois-ci."
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
        @booking.status = "confirmé"
        @booking.user = current_user
        if has_credit[:origin] == 'credit'
          @booking.used_credit = true
        end
        @booking.save
        if @lesson.bookings.where(status: "confirmé").count == 2 && @booking.lesson.user.nil?
          User.where(coach: true).each do |user|
            mail = BookingMailer.with(lesson: @lesson, user: user).invite_coachs
            mail.deliver_now
          end
        end
        flash[:info] = "Vous êtes bien inscrit(e) à la séance"
        redirect_to lessons_path
      else
        flash[:alert] = "Vous n'avez pas de crédit pour réserver une leçon ce mois-ci."
        redirect_to offers_path
      end
    end
  end

  private

  def booking_params
    params.require(:booking).permit(:user_id, :lesson_id)
  end
end
