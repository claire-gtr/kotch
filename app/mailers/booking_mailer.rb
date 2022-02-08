class BookingMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.booking_mailer.invitation.subject

  def invitation
    @user = params[:user] # Instance variable => available in view
    @booking = params[:booking]
    @friend = params[:friend]
    mail(to: @user.email, subject: 'Invitation à une séance Koach & Co')
  end

  def invite_coachs
    @user = params[:user]
    @lesson = params[:lesson]
    mail(to: @user.email, subject: "Proposition de séance Koach & Co")
  end

  def invite_coachs_enterprise
    @user = params[:user]
    @lesson = params[:lesson]
    @enterprise = params[:enterprise]
    mail(to: @user.email, subject: 'Proposition de séance')
  end

  def coach_confirmed
    @user = params[:user]
    @lesson = params[:lesson]
    @booking = params[:booking]
    mail(to: @user.email, subject: 'Confirmation de réservation de ta séance Koach & Co')
  end

  def coach_confirmed_enterprise
    @user = params[:user]
    @lesson = params[:lesson]
    @booking = params[:booking]
    mail(to: @user.email, subject: 'Confirmation de séance')
  end

  def confirmation_email_to_coach
    @user = params[:user]
    @lesson = params[:lesson]
    mail(to: @user.email, subject: 'Validation de ta séance Koach & Co')
  end

  def booking_canceled
    @user = params[:user]
    @lesson = params[:lesson]
    mail(to: @user.email, subject: 'Annulation de réservation Koach & Co')
  end

  def reservation_request_enterprise
    @user = params[:user]
    @lesson = params[:lesson]
    mail(to: @user.email, subject: 'Réservation de séance')
  end

  def enterprise_lesson_booking
    @user = params[:user]
    @lesson = params[:lesson]
    mail(to: @user.email, subject: 'Inscription à une séance')
  end
end
