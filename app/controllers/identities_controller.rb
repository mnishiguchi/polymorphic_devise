class IdentitiesController < ApplicationController
  before_filter :authenticate_identity!
  after_action :verify_authorized

  def index
    @identities = Identity.all
    authorize @identities
  end

  def show
    @identity = Identity.find(params[:id])
    authorize @identity
  end

  def edit

  end

  def update

  end

  def destroy

  end

  # GET   /auth/:id/finish_signup - Add email form
  # PATCH /auth/:id/finish_signup - Update identity data based on the form
  def finish_signup
    @identity = Identity.find(params[:id])

    if request.patch?
      @identity.skip_confirmation_notification!
      if finish_signed_up_but_email_not_confirmed? || @identity.duplicate_email?
        @identity.send_confirmation_instructions
        flash[:info] = I18n.t("devise.confirmations.send_instructions")
        redirect_to "/"
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
