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
      @lessons = Lesson.where(user: current_user).where("date >= ?", Time.now).order('date DESC')
      @message = Message.new
      @friends = current_user.my_friends
      render "lessons/index"
    end
  end

  def accept_invitation
    # verifier assez de crédit
    @booking = Booking.find(params[:booking_id])
    @booking.status = "confirmé"
    authorize @booking
    @booking.save
    @lesson = @booking.lesson
    if @lesson.bookings.where(status: "confirmé").count == 5 && @booking.lesson.user.nil?
      User.where(coach: true).each do |user|
        mail = BookingMailer.with(lesson: @lesson, user: user).invite_coachs
        mail.deliver_now
      end
    end
    redirect_to lessons_path
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
      if @lesson.bookings.where(status: "confirmé").count == 5 && @booking.lesson.user.nil?
        User.where(coach: true).each do |user|
          mail = BookingMailer.with(lesson: @lesson, user: user).invite_coachs
          mail.deliver_now
        end
      elsif @lesson.bookings.where(status: "confirmé").count == 5 && !@booking.lesson.user.nil?
        @lesson.status = "validée"
        @lesson.save
      end
      redirect_to lessons_path
    end
  end

  def destroy
    @booking = Booking.find(params[:id])
    authorize @booking
    @booking.destroy
    redirect_to lessons_path
  end

  private

  def booking_params
    params.require(:booking).permit(:user_id, :lesson_id)
  end
end
