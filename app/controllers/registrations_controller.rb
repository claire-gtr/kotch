class RegistrationsController < Devise::RegistrationsController
  def after_sign_up_path_for(resource)
    # path below should be in your routes
    if resource.coach?
      root_path
      # flash[:alert] = "Un administrateur doit valider votre compte coach."
    else
      offers_path
    end
  end
end
