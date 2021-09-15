class PackOrdersController < ApplicationController
  def create
    packs = [{amount: 500, credit_count: 10, name: 'All inclusive'},
             {amount: 100, credit_count: 1, name: 'Minimal'}]
    chosen_pack = packs[params[:pack_number].to_i]

    pack_order  = PackOrder.new(credit_count: chosen_pack[:credit_count] , amount: chosen_pack[:amount], state: 'pending', user: current_user)
    authorize pack_order
    pack_order.save

    session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      line_items: [{
        name: chosen_pack[:name],
        amount: chosen_pack[:amount],
        promotion_code: 'sTDkk2L5',
        currency: 'eur',
        quantity: 1
      }],
      success_url: pack_order_url(pack_order),
      cancel_url: offers_url
    )

    pack_order.update(checkout_session_id: session.id)
    redirect_to new_pack_order_payment_path(pack_order)
  end

  def show
    @pack_order = current_user.pack_orders.find(params[:id])
    authorize @pack_order
  end
end
