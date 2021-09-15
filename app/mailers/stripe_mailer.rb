class StripeMailer < ApplicationMailer
  # def trial_ended_without_card
  #   @user = params[:user]
  #   mail(to: @user.email, subject: "Votre période d'essai à easy Endo est terminée")
  # end

  def subscription_canceled
    @user = params[:user]
    mail(to: @user.email, subject: "Annulation de votre abonnement Koach")
  end

  def customer_changed_plan
    @user = params[:user]
    @subscription = params[:subscription]
    mail(to: @user.email, subject: "Votre abonnement Koach & co ")
  end

  def customer_bought_credits
    @user = params[:user]
    @pack_order = params[:pack_order]
    mail(to: @user.email, subject: "Votre achat sur Koach & co ")
  end

  # def invoice_payment_failed
  #   @user = params[:user]
  #   mail(to: @user.email, subject: "Votre paiement n'a pas fonctionné")
  # end
end
