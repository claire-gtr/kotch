class MessagesController < ApplicationController

  def index
    @lesson = Lesson.find(params[:lesson_id])
    @messages = policy_scope(Message)
    @messages = @lesson.messages
    @message = Message.new
  end

  def create
    @lesson = Lesson.find(params[:lesson_id])
    @message = Message.new(message_params)
    @booking = Booking.find_by(user: current_user, lesson: @lesson)
    @message.booking = @booking
    @message.lesson = @booking.lesson
    authorize @message
    if @message.save
      redirect_to lesson_messages_path#(anchor: "form-message")
    else
      @message = Message.new
      render 'messages#index'
    end
  end

  def coach_message
    @lesson = Lesson.find(params[:lesson_id])
    @message = Message.new(message_params)
    @message.lesson = @lesson
    authorize(:message, :coach_message?)
    if @message.save
      redirect_to lesson_messages_path#(anchor: "form-message")
    else
      @message = Message.new
      render 'messages#index'
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
