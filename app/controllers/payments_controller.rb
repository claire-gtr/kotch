class PaymentsController < ApplicationController
  def new
    @pack_order = current_user.pack_orders.where(state: 'pending').find(params[:pack_order_id])
    authorize(:payment, :new?)
  end
end
