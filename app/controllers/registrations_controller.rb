class RegistrationsController < Devise::RegistrationsController
  def after_sign_up_path_for(resource)
    #path below should be in your routes
    offers_path
  end
end
