class MessagesController < ApplicationController

  def create
    @booking = Booking.find(params[:booking_id])
    @message = Message.new(message_params)
    @message.booking = @booking
    @message.lesson = @booking.lesson
    authorize @message
    if @message.save
      redirect_to bookings_path(anchor: "form-message")
    else
      @message = Message.new
      render 'bookings#index'
    end
  end

  def coach_message
    @lesson = Lesson.find(params[:lesson_id])
    @message = Message.new(message_params)
    @message.lesson = @lesson
    authorize(:message, :coach_message?)
    if @message.save
      redirect_to lessons_path(anchor: "form-message")
    else
      @message = Message.new
      render 'bookings#index'
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
