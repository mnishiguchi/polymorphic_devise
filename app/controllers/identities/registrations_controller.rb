# https://github.com/plataformatec/devise/blob/master/app/controllers/devise/registrations_controller.rb
class Identities::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  respond_to :html, :js

  # POST /resource
  def create
    build_resource(sign_up_params)

    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
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
      respond_with resource
    end
  end

  def update
    # We determine update_type based on params keys so that we can render
    # a specific partial for that update_type.
    @update_type = identity_params[:current_password] ? :password : :email
    
    super
  end

  private

    def update_resource(resource, params)
      return super if params.fetch("current_password") { false }

      # Allows user to update registration information without password.
      resource.update_without_password(params)
    end

    def identity_params
      # We use the keys email and currrent_password to distinguish between each other.
      accessible = [ :email, :current_password ]
      params.require(:identity).permit(accessible)
    end
end
