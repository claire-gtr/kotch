class UserMailer < ApplicationMailer
  def welcome_mail
    @user = params[:user]
    mail(to: @user.email, subject: 'Confirmation de création de ton compte Koach & Co')
  end

  def welcome_mail_enterprise
    @user = params[:user]
    mail(to: @user.email, subject: 'Confirmation de création de votre compte entreprise Koach & Co')
  end

  def coach_validated
    @user = params[:user]
    mail(to: @user.email, subject: 'Validation de ton compte Koach & Co')
  end

  def unsubscribed_newsletter
    @user = params[:user]
    @reason = Reason.new
    @all_reasons = all_reasons
    mail(to: @user.email, subject: 'Désabonnement à la newsletter Koach & Co')
  end
end
