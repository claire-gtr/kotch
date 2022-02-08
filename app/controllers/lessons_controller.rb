class LessonsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:public_lessons]

  def index
    @lessons = policy_scope(Lesson).includes([:user, :bookings, :users, :location]).where.not(status: 'canceled').order('date ASC')
    @message = Message.new
    @friends = current_user.my_friends
    @booking = Booking.new
    @pending_invitations = Booking.where(status: "Invitation envoyée", user: current_user)
  end

  def new
    @lesson = Lesson.new
    @friends = current_user.my_friends
    authorize @lesson
    if current_user.coach && !current_user.validated_coach
      flash[:alert] = "Un administrateur doit valider votre compte coach."
      redirect_to root_path
    else
      @locations = Location.where(visible: true).order(name: :asc)
      @markers = @locations.geocoded.map do |location|
        {
          lat: location.latitude,
          lng: location.longitude,
          info_window: render_to_string(partial: "info_window", locals: { location: location })
        }
      end
    end
  end

  def create
    if current_user.coach? && !current_user.validated_coach?
      flash[:alert] = "Un administrateur doit valider votre compte coach."
      redirect_to root_path
    else
      @lesson = Lesson.new(lesson_params)
      authorize @lesson
      if params[:address].present?
        @new_location = Location.new(user: current_user, name: params[:address])
        @lesson.location = @new_location
      end
      if current_user.coach?
        @lesson.public = true
        @lesson.user = current_user
        if @lesson.save
          @new_location&.save
          redirect_to profile_path
        else
          render :new
        end
      else
        has_credit = current_user.has_credit(@lesson.date)
        if has_credit[:has_credit] == true
          @booking = Booking.new
          @booking.user = current_user
          @booking.lesson = @lesson
          @booking.status = "Confirmé"
          if has_credit[:origin] == 'credit'
            @booking.used_credit = true
          end
          @booking.save
          if @lesson.save
            @new_location&.save
            if current_user.enterprise?
              mail = BookingMailer.with(lesson: @lesson, user: current_user).reservation_request_enterprise
              mail.deliver_now
              invite_coachs_enterprise(@lesson, current_user)
              set_reccurency_lessons(@lesson, @booking)
            end
            redirect_to lessons_path
          else
            render :new
          end
          friend_ids= params[:friends]
          if friend_ids
            friend_ids.each do |id|
              user = User.find(id.to_i)
              booking = Booking.new(user: user, lesson: @lesson)
              booking.status = "Invitation envoyée"
              booking.save
              mail = BookingMailer.with(user: user, booking: booking, friend: current_user).invitation
              mail.deliver_now
            end
          end
          friends_emails = params[:emails]
          if friends_emails && (friends_emails != "")
            emails = friends_emails.split(',').map { |email| email.gsub(/\s+/, '').downcase }
            emails.each do |email|
              if a_valid_email?(email)
                user = User.find_by(email: email)
                if user.present?
                  booking = Booking.new(user: user, lesson: @lesson)
                  booking.status = "Invitation envoyée"
                  booking.save
                  mail = BookingMailer.with(user: user, booking: booking, friend: current_user).invitation
                else
                  WaitingBooking.create(user_email: email, lesson: @lesson)
                  mail = LessonMailer.with(user_email: email, lesson: @lesson, friend: current_user).new_user_inviation
                end
                mail.deliver_now
              end
            end
          end
        else
          flash[:alert] = "Vous n'avez pas de crédits pour réserver une séance ce mois-ci.."
          redirect_to offers_path
        end
      end
    end
  end

  def cancel
    @lesson = Lesson.find(params[:id])
    @cancel_customer = User.find(params[:cancel_customer_id]) if params[:cancel_customer_id].present?
    authorize @lesson
    @lesson.bookings&.each do |b|
      @customer = b.user
      if b.used_credit
        @customer.update(credit_count: @customer.credit_count + 1)
      end
      b.destroy

      if @customer.enterprise?
        mail = LessonMailer.with(user: @customer, lesson: @lesson).lesson_canceled_enterprise
      else
        if @lesson.enterprise?
          mail = LessonMailer.with(user: @customer, lesson: @lesson).lesson_canceled_employee
        elsif @cancel_customer.present? && (@cancel_customer == @customer)
          mail = LessonMailer.with(user: @customer, lesson: @lesson, cancel_customer: @cancel_customer).lesson_canceled_creator
        elsif @cancel_customer.present?
          mail = LessonMailer.with(user: @customer, lesson: @lesson, cancel_customer: @cancel_customer).lesson_canceled_customer
        else
          mail = LessonMailer.with(user: @customer, lesson: @lesson).lesson_canceled
        end
      end
      mail.deliver_now
    end

    if @customer.enterprise? && @cancel_customer.present? && @lesson.user.present?
      mail = LessonMailer.with(user: @lesson.user, lesson: @lesson, cancel_customer: @cancel_customer).lesson_canceled_coach_enterprise
      mail.deliver_now
    elsif @cancel_customer.present? && @lesson.user.present?
      mail = LessonMailer.with(user: @lesson.user, lesson: @lesson, cancel_customer: @cancel_customer).lesson_canceled_coach
      mail.deliver_now
    end
    @lesson.update(status: 'canceled')
    redirect_to lessons_path, notice: 'La séance a bien été annulée.'
  end

  def change_lesson_public
    @lesson = Lesson.find(params[:id])
    authorize @lesson
    @lesson.public = true
    @lesson.save
    redirect_to lessons_path, notice: 'La séance a bien été passée en publique.'
  end

  def public_lessons
    authorize(:lesson, :public_lessons?)
    if user_signed_in?
      if current_user.coach? && !current_user.validated_coach?
        flash[:alert] = "Un administrateur doit valider votre compte coach."
        redirect_to root_path
      elsif current_user.coach?
        @lessons_in_future = Lesson.includes([:location, :bookings, :users, :user]).where(public: true).where("date >= ?", Time.now).where.not(status: 'canceled').order('date ASC')
        @pre_validated_lessons = Lesson.includes([:location, :bookings, :users, :user]).where("date >= ?", Time.now).where(status: "Pre-validée").order('date ASC')
        @lessons = []
        @pre_validated_lessons.each do |lesson|
          @lessons << lesson
        end
        @lessons_in_future.each do |lesson|
          if (lesson.bookings.where(status: "Confirmé").count >= 5) && !@lessons.include?(lesson)
            @lessons << lesson
          end
        end
      end
    end
    if params[:day].present?
      @lessons = Lesson.includes([:location, :bookings, :users, :user]).where("DATE_PART('dow', date)=?", params[:day]).where(public: true).where("date >= ?", Time.now).where.not(status: 'canceled').order('date ASC')
    elsif params[:start].present?
      @lessons = Lesson.includes([:location, :bookings, :users, :user]).where('EXTRACT(hour FROM date) BETWEEN ? AND ?', params[:start], params[:end]).where(public: true).where("date >= ?", Time.now).where.not(status: 'canceled').order('date ASC')
    elsif params[:lieu].present?
      all_lessons = Lesson.includes([:location, :bookings, :users, :user]).where(public: true).where("date >= ?", Time.now).where.not(status: 'canceled').order('date ASC')
      @lessons = []
      all_lessons.each do |lesson|
        locations = Location.near(params[:lieu], 1)
        if locations.include?(lesson.location)
          @lessons << lesson
        end
      end
    elsif params[:activity].present?
      @lessons = Lesson.includes([:location, :bookings, :users, :user]).where(public: true, sport_type: params[:activity]).where("date >= ?", Time.now).where.not(status: 'canceled').order('date ASC')
    else
      @lessons = Lesson.includes([:location, :bookings, :users, :user]).where(public: true).where("date >= ?", Time.now).where.not(status: 'canceled').order('date ASC')
    end
  end

  def be_coach
    if current_user.coach? && !current_user.validated_coach
      flash[:alert] = "Un administrateur doit valider votre compte coach."
      redirect_to root_path
    else
      @lesson = Lesson.find(params[:id])
      authorize @lesson
      if @lesson.user.nil?
        @lesson.user = current_user
        @lesson.status = "Validée"
        @lesson.save
        flash[:notice] = "Vous êtes désormais le coach de cette séance."
        send_email_to_users
        redirect_to profile_path
      else
        flash[:alert] = "Un coach s'est déjà positionné sur cette séance."
        redirect_to public_lessons_path
      end
    end
  end

  def be_coach_via_mail
    if current_user.coach && !current_user.validated_coach
      flash[:alert] = "Un administrateur doit valider votre compte coach."
      redirect_to root_path
    else
      @lesson = Lesson.find(params[:lesson_id])
      @user = User.find(params[:user_id])
      authorize @lesson
      if @lesson.user.nil?
        @lesson.user = @user
        @lesson.status = "Validée"
        @lesson.save
        send_email_to_users
        flash[:notice] = "Vous êtes désormais le coach de cette séance."
        redirect_to profile_path
      else
        flash[:alert] = "Un coach s'est déjà positionné sur cette séance."
        redirect_to public_lessons_path
      end
    end
  end

  def lesson_done
    @lesson = Lesson.find(params[:id])
    @lesson.status = "effectuée"
    authorize @lesson
    @lesson.save
    redirect_to profile_path, notice: 'Vous avez indiqué que la séance est effectuée.'
  end

  def lesson_not_done
    @lesson = Lesson.find(params[:id])
    @lesson.status = "non effectuée"
    authorize @lesson
    @lesson.save
    redirect_to profile_path, notice: "Vous avez indiqué que la séance n'a pas été effectuée."
  end

  def focus_lesson
    @lesson = Lesson.find(params[:id])
    @lesson.update(lesson_params)
    authorize @lesson
    @lesson.save
    redirect_to profile_path
  end

  def pre_validate_lesson
    @lesson = Lesson.find(params[:id])
    authorize @lesson
    @lesson.status = "Pre-validée"
    @lesson.save

    if @lesson.user
      mail = BookingMailer.with(user: @lesson.user, lesson: @lesson).confirmation_email_to_coach
      mail.deliver_now
    else
      User.where(coach: true).each do |user|
        mail = BookingMailer.with(lesson: @lesson, user: user).invite_coachs
        mail.deliver_now
      end
    end

    redirect_to all_lessons_path
  end

  def invite_enterprise_employees
    @lesson = Lesson.find(params[:id])
    authorize @lesson
    employees = current_user.employees
    employees_booking = @lesson.users
    employees.each do |employee|
      unless employees_booking.include?(employee)
        mail = LessonMailer.with(lesson: @lesson, user: employee, enterprise: current_user).invite_employee
        mail.deliver_now
      end
    end
    redirect_to lessons_path, notice: 'Vos employés ont bien été invités'
  end

  def employee_enterprise_lessons
    authorize(:lesson, :employee_enterprise_lessons?)
    @enterprise_bookings = current_user.enterprise&.enterprise_futur_bookings
    return if @enterprise_bookings.empty?

    if params[:day].present?
      @enterprise_bookings = @enterprise_bookings.by_lesson_date(params[:day])
    elsif params[:start].present?
      @enterprise_bookings = @enterprise_bookings.by_lesson_start_end([params[:start], params[:end]])
    elsif params[:lieu].present?
      @bookings = @enterprise_bookings
      @enterprise_bookings = []
      @bookings.each do |booking|
        lesson = booking.lesson
        locations = Location.near(params[:lieu], 1)
        if locations.include?(lesson.location)
          @enterprise_bookings << booking
        end
      end
    elsif params[:activity].present?
      @enterprise_bookings = @enterprise_bookings.by_lesson_activity(params[:activity])
    end
  end

  private

  def send_email_to_users
    @lesson.bookings.where(status: "Confirmé").each do |booking|
      user = booking.user
      if user.enterprise?
        mail = BookingMailer.with(user: user, booking: booking, lesson: @lesson).coach_confirmed_enterprise
      else
        mail = BookingMailer.with(user: user, booking: booking, lesson: @lesson).coach_confirmed
      end
      mail.deliver_now
    end
  end

  def lesson_params
    params.require(:lesson).permit(:date, :location_id, :sport_type, :focus, :reccurency, :status)
  end

  def invite_coachs_enterprise(lesson, enterprise)
    User.validated_coachs.each do |user|
      mail = BookingMailer.with(lesson: lesson, user: user, enterprise: enterprise).invite_coachs_enterprise
      mail.deliver_now
    end
  end

  def set_reccurency_lessons(lesson, booking)
    has_credit = current_user.has_credit(lesson.date)
    return if lesson.not_reccurent? || lesson.status != 'Pre-validée' || has_credit[:has_credit] == false || current_user.person?

    credit_number = has_credit[:number]
    if lesson.weekly?
      remaining_weeks_in_lesson_month = (lesson.date.to_date.end_of_month - lesson.date.to_date).to_i / 7
      number = remaining_weeks_in_lesson_month <= credit_number ? remaining_weeks_in_lesson_month : credit_number
      number.times do |i|
        new_lesson = lesson.dup
        new_lesson.date = lesson.date + ((i + 1) * 7).days
        new_lesson.reccurency = :not_reccurent
        new_lesson.status = 'Pre-validée'
        new_lesson.save
        new_booking = booking.dup
        new_booking.lesson = new_lesson
        new_booking.save
        invite_coachs_enterprise(new_lesson, current_user)
      end
    end
  end
end
