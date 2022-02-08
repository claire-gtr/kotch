class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:unsubscribe_newsletter]

  def profile
    @tab = params[:tab]
    @user = current_user
    authorize @user
    if current_user.coach? && !current_user.validated_coach?
      flash[:alert] = "Un administrateur doit valider votre compte coach."
      redirect_to root_path
    elsif current_user.coach? && current_user.validated_coach?
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
      return redirect_to root_path, notice: "#{@user.enterprise? ? 'Vôtre' : 'Ta'} désinscription à la newsletter a bien été prise en compte."
    elsif @user.present? && (@user.terms == false)
      authorize @user
      return redirect_to root_path, alert: "#{@user.enterprise? ? "Vous n'êtes" : "Tu n'es"} pas inscrit à la newsletter de Koach & Co."
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
    if @promo_code.present? && current_user.user_codes.find_by(promo_code: @promo_code).present?
      redirect_to profile_path(tab: 'tab-3'), alert: 'Vous avez déjà utilisé ce code promo.'
    elsif @promo_code.present?
      @user.update(credit_count: @user.credit_count + 1)
      @promo_code.update(uses_count: @promo_code.uses_count + 1)
      UserCode.create(user: current_user, promo_code: @promo_code)
      redirect_to profile_path(tab: 'tab-3'), notice: 'Le code promo a bien été pris en compte.'
    elsif @user_sponsor.present? && (@user_sponsor == current_user)
      redirect_to profile_path(tab: 'tab-3'), alert: 'Vous ne pouvez pas utiliser votre propre code de parrainage.'
    elsif @user_sponsor.present? && @user.promo_code_used?
      redirect_to profile_path(tab: 'tab-3'), alert: 'Vous ne pouvez pas utiliser plusieurs codes de parrainage.'
    elsif @user_sponsor.present?
      @user.update(promo_code_used: true, credit_count: @user.credit_count + 1)
      redirect_to profile_path(tab: 'tab-3'), notice: 'Le code de parrainage a bien été pris en compte.'
    else
      redirect_to profile_path(tab: 'tab-3'), alert: "Ce code n'existe pas ou n'est plus actif."
    end
  end

  private

  def define_coach_profile
    @coachings = current_user.lessons.includes([:location, bookings: :user])
    @coachings_in_future = @coachings.where("date >= ?", Time.now).order('date ASC')
    @coachings_in_past = @coachings.where("date < ?", Time.now).order('date DESC')
    @coachings_done = @coachings.where(status: "effectuée")

    @all_coachings_in_future_without_coach = Lesson.all.where("date >= ?", Time.now).where(user: nil).order('date ASC')
    @pre_validated_coachings = Lesson.where("date >= ?", Time.now).where(status: "Pre-validée").where(user: nil).order('date ASC')
    @coachings_requests = []
    @pre_validated_coachings.each do |lesson|
      @coachings_requests << lesson
    end
    @all_coachings_in_future_without_coach.each do |lesson|
      if lesson.enterprise?
        @coachings_requests << lesson
      elsif lesson.bookings.count >= 5 && !@coachings_requests.include?(lesson)
        @coachings_requests << lesson
      end
    end
    @coachings_requests = @coachings_requests.uniq

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
    @bookings = current_user.bookings.includes([[lesson: [:user, :location]], :user]).sort_by { |booking| DateTime.now - booking.lesson.date.to_datetime }
    @bookings_in_future = []
    @bookings_in_past = []
    @bookings.each do |booking|
      if booking.lesson.date >= Time.now
        @bookings_in_future << booking
      else
        @bookings_in_past << booking
      end
    end
    @bookings_in_future = @bookings_in_future.reverse

    if current_user.subscription.active?
      subscription = current_user.subscription
      @included_lessons = subscription.nickname.first(2).to_i
      @used_this_month = 0
      current_user.bookings.includes([:lesson, :user]).where(used_credit: false).sort_by { |booking| DateTime.now - booking.lesson.date.to_datetime }.each do |b|
        if b.lesson.date.to_date >= Date.today.beginning_of_month && b.lesson.date.to_date <= Date.today.end_of_month && b.lesson.status != "canceled"
          @used_this_month += 1
        end
      end
    end
    @employment = Employment.new
    @user_employment = Employment.find_by(employee: current_user, accepted: true)
    @user_employment_send = Employment.find_by(employee: current_user, accepted: nil)
  end
end
