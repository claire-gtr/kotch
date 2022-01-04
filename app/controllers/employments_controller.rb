class EmploymentsController < ApplicationController
  def index
    @employments_received = policy_scope(Employment).where(enterprise: current_user)
    @employments_accepted = @employments_received.where(accepted: true)
    @employments_to_check = @employments_received.where(accepted: nil)

    #   if params[:employee_query].present?
    #     @my_friends = current_user.friendships.select do |friendship|
    #       friendship.friend_a.first_name.downcase == params[:employee_query].downcase.gsub(/\s+/, '') ||
    #       friendship.friend_b.first_name.downcase == params[:employee_query].downcase.gsub(/\s+/, '') ||
    #       friendship.friend_a.last_name.downcase == params[:employee_query].downcase.gsub(/\s+/, '') ||
    #       friendship.friend_b.last_name.downcase == params[:employee_query].downcase.gsub(/\s+/, '')
    #     end
    #     if @my_friends.empty?
    #       flash[:alert] = "Aucun compte utilisateur ne correspond à votre recherche ou bien les informations renseignées contiennent des erreurs."
    #     end
    #   else
    #     @my_friends = current_user.friendships
    #   end

    #   if params[:email].present?
    #     @new_friends = User.all.select do |user|
    #       user.email.downcase == params[:email].downcase.gsub(/\s+/, '')
    #     end
    #     if @new_friends.empty?
    #       flash[:alert] = "Aucun compte utilisateur ne correspond à votre recherche ou bien les informations renseignées contiennent des erreurs."
    #     end
    #   elsif params[:first_name].present? && params[:last_name].present?
    #     @new_friends = User.all.select do |user|
    #       (user.first_name.downcase == params[:first_name].downcase.gsub(/\s+/, '')) &&
    #       (user.last_name.downcase == params[:last_name].downcase.gsub(/\s+/, ''))
    #     end
    #     if @new_friends.empty?
    #       flash[:alert] = "Aucun compte utilisateur ne correspond à votre recherche ou bien les informations renseignées contiennent des erreurs."
    #     end
    #   else
    #     @new_friends = []
    #   end
    # end
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
end
