class Identities::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook;      omniauth_callback; end
  def google_oauth2; omniauth_callback; end
  def twitter;       omniauth_callback; end

  private

    # Invoked after omniauth authentication is done.
    # This method can handle authentication for all the providers.
    # Alias this method as a provider name such as `twitter`, `facebook`, etc.
    def omniauth_callback

      # Obtain the authentication data.
      @auth_hash = request.env["omniauth.auth"]

      # Check if identity is alreadly signed in.
      if identity_signed_in?
        # Create a social profile from auth and ssociate that with current identity.
        profile = SocialProfile.find_or_create_from_omniauth(@auth_hash)
        profile.associate_with_identity(@current_identity)
        flash[:success] = "Connected to #{formatted_provider_name(@auth_hash.provider)}."
        redirect_to(edit_identity_registration_url) and return
      end

      # Obtain identity by auth data.
      @identity = Identity.find_or_create_from_omniauth(@auth_hash)

      # Obtain identity by email or create a new identity.
      if @identity.persisted? && @identity.email_verified?
        sign_in @identity
        flash[:success] = "Successfully authenticated from #{SocialProfile.format_provider_name(@auth_hash.provider)} account."
        redirect_back_or root_url
      else
        @identity.reset_confirmation!
        flash[:warning] = "Please enter your email address to sign in or create an account on this app."
        redirect_to identity_finish_signup_url(@identity)
      end
    end
end
