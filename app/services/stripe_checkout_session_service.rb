class StripeCheckoutSessionService
  def call(event)
    if event.data.object.mode == "payment"
      pack_order = PackOrder.find_by(checkout_session_id: event.data.object.id)
      pack_order.update(state: 'paid')
      user = pack_order.user
      user.update(credit_count: (user.credit_count + pack_order.credit_count))
      if user.referral_code == ""
        new_referral_code = [*('a'..'z'), *('0'..'9')].sample(10).join.upcase
        while User.find_by(referral_code: new_referral_code).present?
          new_referral_code = [*('a'..'z'), *('0'..'9')].sample(10).join.upcase
        end
        user.update(referral_code: new_referral_code)
      end
      StripeMailer.with(user: user, pack_order: pack_order).customer_bought_credits.deliver_now
    end
  end
end
