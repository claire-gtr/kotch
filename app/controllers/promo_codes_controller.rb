class PromoCodesController < ApplicationController
  def create
    params[:promo_code][:name].upcase!
    @promo_code = PromoCode.new(promo_code_params)
    authorize @promo_code
    if @promo_code.save
      redirect_to dashboard_path, notice: 'Le code promo a bien été créé.'
    else
      redirect_back fallback_location: dashboard_path, alert: 'Erreur de saisie.'
    end
  end

  def toggle_active_status
    @promo_code = PromoCode.find(params[:id])
    authorize @promo_code
    if @promo_code.update(active: !@promo_code.active)
      redirect_to dashboard_path, notice: 'Modification effectuée !'
    else
      redirect_back fallback_location: dashboard_path, alert: 'Erreur de saisie.'
    end
  end

  private

  def promo_code_params
    params.require(:promo_code).permit(:name)
  end
end
