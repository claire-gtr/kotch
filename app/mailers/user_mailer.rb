class UserMailer < ApplicationMailer
  def welcome_mail
    @user = params[:user]
    mail(to: @user.email, subject: 'Confirmation de création de ton compte Koach & Co')
  end

  def coach_validated
    @user = params[:user]
    mail(to: @user.email, subject: 'Validation de ton compte Koach & Co')
  end

  def unsubscribed_newsletter
    @user = params[:user]
    mail(to: @user.email, subject: 'Désabonnement à la newsletter Koach & Co')
  end
end
