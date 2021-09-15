class StripeCheckoutSessionService
  def call(event)
    pack_order = PackOrder.find_by(checkout_session_id: event.data.object.id)
    pack_order.update(state: 'paid')
    pack_order.user.update(credit_count: (pack_order.user.credit_count + pack_order.credit_count))
    StripeMailer.with(user: pack_order.user, pack_order: pack_order).customer_bought_credits.deliver_now
  end
end
