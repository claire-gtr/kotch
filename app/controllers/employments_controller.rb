class EmploymentsController < ApplicationController
  def index
    @employments_received = policy_scope(Employment).where(enterprise: current_user)
    @employments_to_check = @employments_received.where(accepted: nil)

    if params[:employee_query].present?
      @employments_accepted = @employments_received.where(accepted: true).select do |employment|
        employment.employee.first_name.downcase == params[:employee_query].downcase.gsub(/\s+/, '') ||
        employment.employee.last_name.downcase == params[:employee_query].downcase.gsub(/\s+/, '')
      end
      if @employments_accepted.empty?
        flash[:alert] = "Aucun compte utilisateur ne correspond à votre recherche ou bien les informations renseignées contiennent des erreurs."
      end
    else
      @employments_accepted = @employments_received.where(accepted: true)
    end
  end

  def create
    authorize Employment.new
    @enterprise = User.find_by(enterprise_code: params[:enterprise_code].gsub(/\s+/, '').upcase)
    if @enterprise.present?
      Employment.create(enterprise: @enterprise, employee: current_user)
      redirect_to profile_path(tab: 'tab-3'), notice: "Votre demande d'accès a bien été envoyée à l'entreprise."
    else
      redirect_to profile_path(tab: 'tab-3'), alert: "Ce code d'entreprise n'existe pas."
    end
  end

  def update
    @employment = Employment.find(params[:id])
    query = params[:query]
    authorize @employment
    if query == "accept"
      @employment.accepted = true
    elsif query == 'reject'
      @employment.accepted = false
    end
    @employment.save
    redirect_to employments_path, notice: "La demande de #{@employment.employee.full_name} a bien été #{query == 'accept' ? 'acceptée' : 'refusée'}"
  end

  def cancel
    @employment = Employment.find(params[:id])
    query = params[:query]
    authorize @employment
    @employment.update(accepted: false)
    if current_user == @employment.enterprise
      return redirect_to employments_path, notice: "#{@employment.employee.full_name} a bien été retiré de vos salariés"
    else
      if query.present? && query == 'annuler'
        return redirect_to profile_path(tab: 'tab-3'), notice: "Votre demande d'intégration à la liste des salariés de l'entreprise #{@employment.enterprise.enterprise_name.upcase} a bien été annulée"
      else
        return redirect_to profile_path(tab: 'tab-3'), notice: "Vous avez bien été retiré des salariés de l'entreprise #{@employment.enterprise.enterprise_name.upcase}"
      end
    end
  end
end
