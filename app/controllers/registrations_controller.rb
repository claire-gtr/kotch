class RegistrationsController < Devise::RegistrationsController
  def create
    user_type = params[:user_type]
    build_resource(sign_up_params)
    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        if resource.coach?
          set_flash_message! :notice, :signed_up_coach
        elsif resource.enterprise?
          set_flash_message! :alert, :signed_up_enterprise
        else
          set_flash_message! :notice, :signed_up_customer
        end
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length

      if user_type.present? && (user_type == 'enterprise')
        return redirect_to enterprise_sign_up_path, alert: "Erreur(s) de saisie, veuillez renseigner le nom de l'entreprise, le mail et le téléphone du responsable, le mot de passe et accepter les CGU."
      else
        return respond_with resource
      end
    end
  end

  protected

  def after_sign_up_path_for(resource)
    if resource.coach?
      root_path
    else
      offers_path
    end
  end
end
