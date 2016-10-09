class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :set_current_identity

  include ApplicationHelper

  private

    # Make current_identity accessible via Identity.
    def set_current_identity
      Identity.current_identity = @current_identity
    end
end
