class BookingMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.booking_mailer.invitation.subject

  def invitation
    @user = params[:user] # Instance variable => available in view
    @booking = params[:booking]
    mail(to: @user.email, subject: 'Invitation à une séance Koach & Co ')
  end

  def invite_coachs
    @user = params[:user]
    @lesson = params[:lesson]
    mail(to: @user.email, subject: "Une séance Koach a besoin d'un coach !")
  end

  def coach_confirmed
    @user = params[:user]
    @lesson = params[:lesson]
    @booking = params[:booking]
    mail(to: @user.email, subject: "Confirmation de réservation de ta séance Koach & Co")
  end

  def confirmation_email_to_coach
    @user = params[:user]
    @lesson = params[:lesson]
    mail(to: @user.email, subject: "Confirmation de ta séance Koach & Co ")
  end
end
