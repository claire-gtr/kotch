class BookingsController < ApplicationController

  def create
    @booking = Booking.new(booking_params)
    @booking.status = "invitation send"
    @user = @booking.user
    authorize @booking
    if @booking.save
      mail = BookingMailer.with(user: @user, booking: @booking).invitation
      mail.deliver_now
      redirect_to bookings_path
    else
      @bookings = Booking.where(user: current_user)
      @booking = Booking.new
      render :index
    end
  end

  def accept_invitation
    @booking = Booking.find(params[:booking_id])
    @booking.status = "confirmé"
    authorize @booking
    @booking.save
    @lesson = @booking.lesson
    if @lesson.bookings.where(status: "confirmé").count == 2 && @booking.lesson.user.nil?
      User.where(coach: true).each do |user|
        mail = BookingMailer.with(lesson: @lesson, user: user).invite_coachs
        mail.deliver_now
      end
    end
    redirect_to bookings_path
  end

  def public_lesson_booking
    @lesson = Lesson.find(params[:lesson_id])
    if @lesson.bookings.where(user: current_user).any?
      authorize(:booking, :public_lesson_booking?)
      flash[:alert] = "Vous avez déjà une réservation pour cette séance."
      redirect_to public_lessons_path
    elsif !current_user.coach
      @booking = Booking.new
      @booking.lesson = @lesson
      @booking.status = "confirmé"
      @booking.user = current_user
      authorize @booking
      @booking.save
      if @lesson.bookings.where(status: "confirmé").count == 2 && @booking.lesson.user.nil?
        User.where(coach: true).each do |user|
          mail = BookingMailer.with(lesson: @lesson, user: user).invite_coachs
          mail.deliver_now
        end
      end
      redirect_to bookings_path
    end
  end

  private

  def booking_params
    params.require(:booking).permit(:user_id, :lesson_id)
  end
end
