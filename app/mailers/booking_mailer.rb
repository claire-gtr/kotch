class BookingMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.booking_mailer.invitation.subject
  #
  def invitation
    @user = params[:user] # Instance variable => available in view
    @booking = params[:booking]
    mail(to: @user.email, subject: 'Invitation à une séance KOACH')
  end

  def invite_coachs
    @user = params[:user]
    @lesson = params[:lesson]
    mail(to: @user.email, subject: "Une séance coach a besoin d'un coach !")
  end
end
