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
        # Sending a log in link after successful sign up.
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

    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?
    if resource_updated
      # http://www.rubydoc.info/github/plataformatec/devise/DeviseController%3Anavigational_formats
      # http://www.rubydoc.info/github/plataformatec/devise/Devise/Controllers/Helpers#is_flashing_format%3F-instance_method
      # if is_flashing_format?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
          :update_needs_confirmation : :updated
        set_flash_message :notice, flash_key
      # end
      bypass_sign_in resource, scope: resource_name
      respond_with resource, location: after_update_path_for(resource)
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
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
