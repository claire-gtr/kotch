module Stripe
  class CustomerSubscriptionUpdatedService
    def call(event)
      @event = event
      puts event.data.object
      @stripe_subscription = event.data.object
      @user = User.find_by(stripe_id: @stripe_subscription.customer)

      if @user.subscription.stripe_id.nil?
        @user.subscription.update(
          user: @user,
          stripe_id: @stripe_subscription.id,
          status: @stripe_subscription.status,
          end_date: Time.at(@stripe_subscription.current_period_end).to_date
          )
        send_first_sub_email
      else
        @user.subscription.update(
          stripe_id: @stripe_subscription.id,
          status: @stripe_subscription.status,
          end_date: Time.at(@stripe_subscription.current_period_end).to_date
          )
      end
      puts @stripe_subscription
      if @stripe_subscription&.items&.data[0]&.plan
        @user.subscription.update(
          nickname: @stripe_subscription&.items&.data[0]&.plan&.nickname
          )
      end
      check_if_canceled
      # check_change_price
      # if @first_sub
      #   send_first_sub_email
      # end
    # rescue StandardError => e
    #   channel = Rails.env.development? ? 'DEVELOPMENT' : 'PRODUCTION'
    #   Zapier::StripeError.new({ event: event, error: e.message, channel: channel, service: "CustomerSubscriptionUpdated" }).post_to_zapier
    end

    private

    def check_if_first_subscription
      if @user.subscription.stripe_id.nil?
        @first_sub = true
      end
    end

    def send_first_sub_email
      StripeMailer.with(user: @user, subscription: @user.subscription).customer_changed_plan.deliver_now
    end

    def check_change_price
      #persister le prix chez nous pour retrouver plus facilement ou voir avec le nickname
      if @event.data&.previous_attributes.keys.include?(:items)
        status = @stripe_subscription.status
        price_id = @stripe_subscription&.items&.data[0]&.price&.id
        previous_price_id = @event.data&.previous_attributes&.items&.data[0]&.price&.id

        if previous_price_id && (previous_price_id != price_id) && status == "active"
          @subscription_duration = @stripe_subscription.items.data[0].plan.interval_count
          @interval = @stripe_subscription.items.data[0].plan.interval
          @interval == "month" ? @interval = "mois" : @interval = "an"
          StripeMailer.with(user: @user, duration: @subscription_duration, interval: @interval, subscription: @user.subscription).customer_changed_plan.deliver_now
        end
      end
    end

    def check_if_canceled
      if @event.data&.previous_attributes.keys.include?(:cancel_at_period_end) && (@event.data&.previous_attributes[:cancel_at_period_end] == false)
          StripeMailer.with(user: @user).subscription_canceled.deliver_now
      end
    end
  end
end
