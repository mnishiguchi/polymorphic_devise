class IdentitiesController < ApplicationController

  # GET   /identitys/:id/finish_signup - Add email form
  # PATCH /identitys/:id/finish_signup - Update identity data based on the form
  def finish_signup
    @identity = Identity.find(params[:id])

    if request.patch?
      @identity.skip_confirmation_notification!
      if finish_signed_up_but_email_not_confirmed? || @identity.duplicate_email?
        @identity.send_confirmation_instructions
        flash[:info] = 'We sent you a link to sign in. Please check your inbox.'
        redirect_to root_url
      end
    end
  end

  private

    # Returns true if the identity was successfully signed up but
    # his/her email is not confirmed yet.
    def finish_signed_up_but_email_not_confirmed?
      @identity.update(identity_params) && !@identity.confirmed?
    end

    def identity_params
      accessible = [ :email ]

      # Ignore password if password is blank.
      accessible << [ :password, :password_confirmation ] unless params[:identity][:password].blank?
      params.require(:identity).permit(accessible)
    end

end
