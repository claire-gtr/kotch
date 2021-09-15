class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home, :faq, :forum ]

  def home
  end

  def faq
  end

  def forum
    @subjects = Subject.all
  end

  def offers
    prices = [
      { name: "4 séances / mois", price: "30€", id: ENV['PRICE_4_CLASSES'] },
      { name: "8 séances / mois", price: "60€", id: ENV['PRICE_8_CLASSES'] },
      { name: "12 séances / mois", price: "90€", id: ENV['PRICE_12_CLASSES'] }
    ]

    @prices_and_sessions = prices.map do |price|
      session = Stripe::Checkout::Session.create({
        payment_method_types: ['card'],
        line_items: [{
          price: price[:id],
          quantity: 1
        }],
        mode: 'subscription',
        success_url: ENV['SUCCESS_URL_STRIPE'],
        cancel_url: root_url,
        client_reference_id: current_user.id,
        customer: find_or_create_stripe_customer_id
      })
      checkout_id = session.id

      { name: price[:name], price: price[:price], checkout_id: checkout_id }
    end
  end

  def our_offers; end

  private

  def find_or_create_stripe_customer_id
    if !current_user.stripe_id?
      customer = Stripe::Customer.create(
        email: current_user.email
      )
      current_user.update(stripe_id: customer.id)
    end
    current_user.stripe_id
  end
end
