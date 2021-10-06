class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:unsubscribe_newsletter]

  def profile
    @tab = params[:tab]
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
    authorize @user
    @user.validated_coach = true
    @user.save
    mail = UserMailer.with(user: @user).coach_validated
    mail.deliver_now
    redirect_to dashboard_path
  end

  def unsubscribe_newsletter
    @user = User.find(params[:id].to_i) if params[:id]
    if @user.present? && (@user.terms == true)
      authorize @user
      @user.terms = false
      @user.save
      mail = UserMailer.with(user: @user).unsubscribed_newsletter
      mail.deliver_now
      return redirect_to root_path, notice: 'Ta désinscription à la newsletter a bien été prise en compte.'
    elsif @user.present? && (@user.terms == false)
      authorize @user
      return redirect_to root_path, alert: "Tu n'es pas inscrit à la newsletter de Koach & Co."
    else
      authorize User.new
      return redirect_to root_path, alert: "Ce compte n'existe pas."
    end
  end

  def use_a_promo_code
    @user = User.find(params[:id])
    authorize @user
    @promo_code = PromoCode.find_by(active: true, name: params[:code].upcase)
    @user_sponsor = User.find_by(referral_code: params[:code].upcase)
    if @promo_code.present?
      @user.update(promo_code_used: true, credit_count: @user.credit_count + 1)
      @promo_code.update(uses_count: @promo_code.uses_count + 1)
      redirect_to profile_path(tab: 'tab-3'), notice: 'Le code promo a bien été pris en compte.'
    elsif @user_sponsor.present? && (@user_sponsor == current_user)
      redirect_to profile_path(tab: 'tab-3'), alert: 'Vous ne pouvez pas utiliser votre propre code de parrainage.'
    elsif @user_sponsor.present?
      @user.update(promo_code_used: true, credit_count: @user.credit_count + 1)
      redirect_to profile_path(tab: 'tab-3'), notice: 'Le code de parrainage a bien été pris en compte.'
    else
      redirect_to profile_path(tab: 'tab-3'), alert: "Ce code n'existe pas ou n'est plus actif."
    end
  end

  private

  def define_coach_profile
    @coachings = current_user.lessons
    @coachings_in_future = @coachings.where("date >= ?", Time.now)
    @coachings_in_past = @coachings.where("date < ?", Time.now)
    @coachings_done = @coachings.where(status: "effectuée")

    # @all_coachings_in_future_without_coach = @coachings_in_future.where(user: nil)
    @all_coachings_in_future_without_coach = Lesson.all.where("date >= ?", Time.now).where(user: nil)
    @pre_validated_coachings = Lesson.where("date >= ?", Time.now).where(status: "Pre-validée").where(user: nil)
    @coachings_requests = []
    @pre_validated_coachings.each do |lesson|
      @coachings_requests << lesson
    end
    @all_coachings_in_future_without_coach.each do |lesson|
      if lesson.bookings.count >= 5 && !@coachings_requests.include?(lesson)
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
