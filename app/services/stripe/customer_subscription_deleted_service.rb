module Stripe
  class CustomerSubscriptionDeletedService
    def call(event)
      stripe_subscription = event.data.object
      @user = User.find_by(stripe_id: stripe_subscription.customer)
      puts @user
      puts stripe_subscription.status
      @user.subscription.update(
        status: stripe_subscription.status,
        end_date: Time.at(stripe_subscription.current_period_end).to_date
      )
      puts @user.subscription
      @user.update(referral_code: "")
      StripeMailer.with(user: @user).subscription_canceled.deliver_now
    # rescue StandardError => e
    #   channel = Rails.env.development? ? 'DEVELOPMENT' : 'PRODUCTION'
    #   Zapier::StripeError.new({ event: event, error: e.message, channel: channel, service: "CustomerSubscriptionDeleted" }).post_to_zapier
    end
  end
end
