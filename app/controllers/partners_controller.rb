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

  def destroy
    @partner = policy_scope(Partner).find(params[:id])
    authorize @partner
    name = @partner.name
    @partner.destroy
    redirect_to dashboard_path, notice: "Le code entreprise #{name.upcase} a bien été supprimé."
  end

  private

  def partner_params
    params.require(:partner).permit(:name, :domain_name, :coupon_code, :percentage)
  end
end
