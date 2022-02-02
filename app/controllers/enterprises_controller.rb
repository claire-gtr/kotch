class EnterprisesController < ApplicationController
  skip_before_action :authenticate_user!

  def sign_up
    authorize(:enterprise, :sign_up?)
  end
end
