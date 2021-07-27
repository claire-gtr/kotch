class BookingsController < ApplicationController

  def index
    @bookings = policy_scope(Booking)
    @booking = Booking.new
    @friends = current_user.my_friends
    @message = Message.new
  end

  def create
    @booking = Booking.new(booking_params)
    @booking.status = "invitation send"
    @user = @booking.user
    authorize @booking
    if @booking.save
      mail = BookingMailer.with(user: @user, booking: @booking).invitation
      mail.deliver_now
      # IF 5 BOOKINGS MAIL A TOUS LES COACH
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
    redirect_to bookings_path
  end

  private

  def booking_params
    params.require(:booking).permit(:user_id, :lesson_id)
  end
end
