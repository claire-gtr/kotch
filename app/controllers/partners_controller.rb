class PartnersController < ApplicationController
  def create
    @partner = Partner.new(partner_params)
    authorize @partner
    if @partner.save
      redirect_to dashboard_path
    else
      render 'dashboard/show'
    end
  end

  private

  def partner_params
    params.require(:partner).permit(:name, :domain_name, :coupon_code, :percentage)
  end
end
