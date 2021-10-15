class ReasonsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create]
  skip_before_action :verify_authenticity_token, only: [:create]

  def create
    @user = User.find(params[:reason][:user_id].to_i)
    @reason = Reason.new(reason_params)
    @reason.user = @user
    authorize @reason

    if @reason.save
      redirect_to root_path, notice: 'Merci pour votre aide !'
    else
      redirect_to root_path, alert: 'Erreur de saisie'
    end
  end

  private

  def reason_params
    params.require(:reason).permit(:title, :other_text, :user_id)
  end
end
