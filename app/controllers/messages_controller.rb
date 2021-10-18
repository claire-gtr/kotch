class MessagesController < ApplicationController
  def index
    @lesson = Lesson.find(params[:lesson_id])
    if current_user.coach? && (current_user == @lesson.user)
      @lesson.messages&.where(readed: false)&.each { |message| message.update(readed: true) }
    else
      @lesson.bookings&.find_by(user: current_user)&.update(messages_readed: true)
    end
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
      @lesson.bookings.where.not(user: current_user).each { |booking| booking.update(messages_readed: false) }
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
    @message.readed = true
    authorize(:message, :coach_message?)
    if @message.save
      @lesson.bookings.each { |booking| booking.update(messages_readed: false) }
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
