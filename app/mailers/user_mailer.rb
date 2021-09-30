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
    @reason = Reason.new
    @all_reasons = [
      "Je reçois trop d'emails",
      "Le contenu n’est pas pertinent",
      "Je ne suis pas intéressé",
      "Je ne veux plus recevoir d’emails",
      "Autres (à compléter ci-dessous)"
    ]
    mail(to: @user.email, subject: 'Désabonnement à la newsletter Koach & Co')
  end
end
