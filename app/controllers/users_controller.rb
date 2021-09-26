class UsersController < ApplicationController
  def profile
    @user = current_user
    authorize @user
    if current_user.coach && !current_user.validated_coach
      flash[:alert] = "Un administrateur doit valider votre compte coach."
      redirect_to root_path
    elsif current_user.coach && current_user.validated_coach
      define_coach_profile
    else
      define_user_profile
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

  private

  def define_coach_profile
    @coachings = current_user.lessons
    @coachings_in_future = @coachings.where("date >= ?", Time.now)
    @coachings_in_past = @coachings.where("date < ?", Time.now)
    @coachings_done = @coachings.where(status: "effectuée")

    @all_coachings_in_future_without_coach = @coachings_in_future.where(user: nil)
    @pre_validated_coachings = Lesson.where("date >= ?", Time.now).where(status: "Pre-validée").where(user: nil)
    @coachings_requests = []
    @pre_validated_coachings.each do |lesson|
      @coachings_requests << lesson
    end
    @all_coachings_in_future_without_coach.each do |lesson|
      if lesson.bookings.count >= 5
        @coachings_requests << lesson
      end
    end

    # définition du nombre de leçons données par mois.
    if current_user.lessons.any?
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
    end
  end

  def define_user_profile
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

    if current_user.subscription.active?
      subscription = current_user.subscription
      @included_lessons = subscription.nickname.first(2).to_i
      @used_this_month = 0
      current_user.bookings.where(used_credit: false).each do |b|
        if b.lesson.date >= Date.today.beginning_of_month && b.lesson.date <= Date.today.end_of_month && b.lesson.status != "canceled"
          @used_this_month += 1
        end
      end
    end
  end
end
