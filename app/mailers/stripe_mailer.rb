class StripeMailer < ApplicationMailer
  # def trial_ended_without_card
  #   @user = params[:user]
  #   mail(to: @user.email, subject: "Votre période d'essai à easy Endo est terminée")
  # end

  # def subscription_canceled
  #   @user = params[:user]
  #   mail(to: @user.email, subject: "Votre abonnement easy Endo est terminé")
  # end

  def customer_changed_plan
    @user = params[:user]
    @subscription = params[:subscription]
    mail(to: @user.email, subject: "Votre abonnement Koach & co ")
  end

  # def invoice_payment_failed
  #   @user = params[:user]
  #   mail(to: @user.email, subject: "Votre paiement n'a pas fonctionné")
  # end
end
