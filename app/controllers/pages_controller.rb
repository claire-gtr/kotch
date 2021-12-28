class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :faq, :forum, :offers, :cgv, :legals, :about, :concept]

  def home; end

  def faq; end

  def cgv; end

  def legals; end

  def about; end

  def concept; end

  def forum
    @subjects = Subject.all
  end

  def offers
    if current_user && current_user.person?
      prices = [
        { name: "4 séances / mois", price: "50€", price_integer: 50, id: ENV['PRICE_4_CLASSES'], image: "offer-1.png" },
        { name: "8 séances / mois", price: "90€", price_integer: 90, id: ENV['PRICE_8_CLASSES'], image: "offer-2.png" },
        { name: "12 séances / mois", price: "120€", price_integer: 120, id: ENV['PRICE_12_CLASSES'], image: "offer-3.png"}
      ]
      coupon = current_user.coupon
      if coupon[:exist]
        @prices_and_sessions = prices.map do |price|
          session = Stripe::Checkout::Session.create({
            payment_method_types: ['card'],
            line_items: [{
              price: price[:id],
              quantity: 1
            }],
            mode: 'subscription',
            discounts: [{
              coupon: coupon[:code],
            }],
            success_url: ENV['SUCCESS_URL_STRIPE'],
            cancel_url: root_url,
            client_reference_id: current_user.id,
            customer: find_or_create_stripe_customer_id
          })
          checkout_id = session.id

          discounted_price = (price[:price_integer] - (price[:price_integer] * coupon[:percentage] / 100)).to_s + "€"

          { name: price[:name], price: price[:price], checkout_id: checkout_id, image: price[:image], percentage: coupon[:percentage], discounted_price: discounted_price }
        end
      else
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

          { name: price[:name], price: price[:price], checkout_id: checkout_id, image: price[:image], percentage: false, discounted_price: price[:price] }
        end
      end
    elsif current_user && current_user.enterprise?
      prices = [
        { name: "4 séances / mois", price: "280 € HT", price_integer: 336, id: ENV['PRICE_4_ENTERPRISE'], image: "offer-1.png" },
        { name: "8 séances / mois", price: "520 € HT", price_integer: 624, id: ENV['PRICE_8_ENTERPRISE'], image: "offer-2.png" },
        { name: "12 séances / mois", price: "720 € HT", price_integer: 864, id: ENV['PRICE_12_ENTERPRISE'], image: "offer-3.png"}
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

        { name: price[:name], price: price[:price], checkout_id: checkout_id, image: price[:image], percentage: false, discounted_price: price[:price] }
      end
    end
  end

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
