module Stripe
  class CustomerSubscriptionUpdatedService
    def call(event)
      @event = event
      @stripe_subscription = event.data.object
      @user = User.find_by(stripe_id: @stripe_subscription.customer)
      @user.subscription.stripe_id.nil? ? first_sub = true : first_sub = false

      @user.subscription.update(
        stripe_id: @stripe_subscription.id,
        status: @stripe_subscription.status,
        end_date: Time.at(@stripe_subscription.current_period_end).to_date
      )

      if @stripe_subscription&.items&.data[0]&.plan
        @user.subscription.update(
          nickname: @stripe_subscription&.items&.data[0]&.plan&.nickname
          )
      end

      if first_sub
        if @user.person? && @user.referral_code == ""
          @new_referral_code = [*('a'..'z'), *('0'..'9')].sample(10).join.upcase
          while User.find_by(referral_code: @new_referral_code).present?
            @new_referral_code = [*('a'..'z'), *('0'..'9')].sample(10).join.upcase
          end
          @user.update(referral_code: @new_referral_code)
        end
        send_first_sub_email
        # flash[:notice] = "Félicitations ! Vous êtes maintenant inscrit à Koach & Co. Un mail de confirmation vient de vous être adressé. Merci de vérifier vos spams ou courriers indésirables." if @user.enterprise?
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

    def send_first_sub_email
      if @user.enterprise?
        StripeMailer.with(user: @user, subscription: @user.subscription).enterprise_changed_plan.deliver_now
      else
        StripeMailer.with(user: @user, subscription: @user.subscription).customer_changed_plan.deliver_now
      end
    end

    # def check_change_price
    #   #persister le prix chez nous pour retrouver plus facilement ou voir avec le nickname
    #   if @event.data&.previous_attributes.keys.include?(:items)
    #     status = @stripe_subscription.status
    #     price_id = @stripe_subscription&.items&.data[0]&.price&.id
    #     previous_price_id = @event.data&.previous_attributes&.items&.data[0]&.price&.id

    #     if previous_price_id && (previous_price_id != price_id) && status == "active"
    #       @subscription_duration = @stripe_subscription.items.data[0].plan.interval_count
    #       @interval = @stripe_subscription.items.data[0].plan.interval
    #       @interval == "month" ? @interval = "mois" : @interval = "an"
    #       StripeMailer.with(user: @user, duration: @subscription_duration, interval: @interval, subscription: @user.subscription).customer_changed_plan.deliver_now
    #     end
    #   end
    # end

    def check_if_canceled
      if @event.data&.previous_attributes.keys.include?(:cancel_at_period_end) && (@event.data&.previous_attributes[:cancel_at_period_end] == false)
        StripeMailer.with(user: @user).subscription_canceled.deliver_now
      end
    end
  end
end
