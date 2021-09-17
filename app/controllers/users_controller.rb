class UsersController < ApplicationController
  def profile
    @user = current_user
    authorize @user
    if current_user.coach && !current_user.validated_coach
      flash[:alert] = "Un administrateur doit valider votre compte coach."
      redirect_to root_path
    elsif current_user.coach && current_user.validated_coach
      @coachings = current_user.lessons
      @coachings_in_future = []
      @coachings_in_past = []
      @coachings_done = @coachings.where(status: "effectuée")
      @coachings.each do |lesson|
        if lesson.date >= Time.now
          @coachings_in_future << lesson
        else
          @coachings_in_past << lesson
        end
      end
      @all_coachings_in_future_without_coach = Lesson.where("date >= ?", Time.now).where(user: nil)
      @coachings_requests = []
      @all_coachings_in_future_without_coach.each do |lesson|
        if lesson.bookings.count >= 5
          @coachings_requests << lesson
        end
      end

      first_lesson_date = current_user.lessons.pluck(:date).min
      first_day = first_lesson_date.beginning_of_month
      last_day = first_lesson_date.end_of_month
      @all_lessons = []

      if first_day <= Date.today
        until last_day.strftime("%m%Y") == Date.today.next_month.strftime("%m%Y") do
          lessons_count = current_user.lessons.where('date >= ? AND date <= ?', first_day, last_day).where(status: "effectuée").count
          month = l(first_day, format: '%B %Y').capitalize
          @all_lessons << {month: month, count: lessons_count}
          first_day = first_day.next_month
          last_day = first_day.end_of_month
        end
      end
      @all_lessons
    else
      @bookings = current_user.bookings
      @bookings_in_future = []
      @bookings_in_past = []
      @bookings.each do |booking|
        if booking.lesson.date >= Time.now
          @bookings_in_future << booking
        else
          @bookings_in_past << booking
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
