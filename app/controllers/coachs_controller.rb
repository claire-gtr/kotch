class CoachsController < ApplicationController
  skip_before_action :authenticate_user!

  def sign_up
    authorize(:coach, :sign_up?)
  end
end
