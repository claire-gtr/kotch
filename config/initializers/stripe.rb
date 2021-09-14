Rails.configuration.stripe = {
  publishable_key: ENV['STRIPE_PUBLISHABLE_KEY'],
  secret_key:      ENV['STRIPE_SECRET_KEY'],
  signing_secret:  ENV['STRIPE_WEBHOOK_SECRET_KEY']
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
StripeEvent.signing_secret = Rails.configuration.stripe[:signing_secret]

StripeEvent.configure do |events|
  events.subscribe 'customer.subscription.updated', Stripe::CustomerSubscriptionUpdatedService.new
  # events.subscribe 'customer.subscription.deleted', Stripe::CustomerSubscriptionDeletedService.new
  # events.subscribe 'invoice.payment_failed', Stripe::InvoicePaymentFailedService.new
  events.subscribe 'checkout.session.completed', StripeCheckoutSessionService.new
end
