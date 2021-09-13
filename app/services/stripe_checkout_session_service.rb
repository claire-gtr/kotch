class StripeCheckoutSessionService
  def call(event)
    pack_order = PackOrder.find_by(checkout_session_id: event.data.object.id)
    pack_order.update(state: 'paid')
  end
end
