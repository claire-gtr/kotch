class UsersController < ApplicationController
  def profile
    @user = current_user
    authorize @user
    if current_user.coach && !current_user.validated_coach
      flash[:alert] = "Un administrateur doit valider votre compte coach."
      redirect_to root_path
    else
      @bookings = current_user.bookings
      @bookings_in_future = []
      @bookings_in_past = []
      @bookings.each do |booking|
        if booking.lesson.date >= Time.now
          @bookings_in_future << booking
        end
      end
      @bookings.each do |booking|
        if booking.lesson.date < Time.now
          @bookings_in_past << booking
        end
      end
      @coachings = current_user.lessons
      @coachings_in_future = []
      @coachings_in_past = []
      @coachings.each do |lesson|
        if lesson.date >= Time.now
          @coachings_in_future << lesson
        end
      end
      @coachings.each do |lesson|
        if lesson.date < Time.now
          @coachings_in_past << lesson
        end
      end

    end
  end

  def become_admin
    @user = User.find(params[:user][:id])
    authorize @user
    @user.admin = true
    @user.save
    redirect_to dashboard_path
  end

  def undo_admin
    @user = User.find(params[:id])
    authorize @user
    @user.admin = false
    @user.save
    redirect_to dashboard_path
  end

  def sportive_profile
    @user = User.find(params[:id])
    authorize @user
  end

  def coach_validation
    @user = User.find(params[:user][:id])
    @user.validated_coach = true
    @user.save
    redirect_to dashboard_path
    authorize @user
  end
end
