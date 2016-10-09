class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include SessionsHelper

  private

    # Make current_identity accessible via Identity.
    def set_current_identity
      Identity.current_identity = current_identity
    end
end
