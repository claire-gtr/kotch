class UserMailer < ApplicationMailer
  def welcome_mail
    @user = params[:user]
    mail(to: @user.email, subject: 'Bienvenue sur Koach & Co')
  end

  def coach_validated
    @user = params[:user]
    mail(to: @user.email, subject: 'Votre compte est validé sur Koach & Co')
  end
end
