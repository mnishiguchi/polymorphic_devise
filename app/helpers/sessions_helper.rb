module SessionsHelper

  # Returns the identity corresponding to the remember token cookie.
  def current_identity
    if (identity_id = session[:identity_id])
      @current_identity ||= Identity.find_by(id: identity_id)
    elsif (identity_id = cookies.signed[:identity_id])
      identity = Identity.find_by(id: identity_id)
      session[:identity_id] = identity.id
      @current_identity = identity
    end
  end

  def current_backend_user
    @current_backend_user ||= (current_identity&.backend_user)
  end

  def current_user
    @current_user ||= (current_identity&.user)
  end

  # log in the given user
  def log_in(identity)
    session[:identity_id] = identity.id
  end

  # Returns true if the identity is logged in, false otherwise.
  def logged_in?
    !current_identity.nil?
  end

  # Logs out the current identity.
  def log_out
    session.delete(:identity_id)
    @current_identity = nil
  end

  def link_to_user_page(text, options={})
    url = if current_user
            user_url(current_user)
          elsif current_backend_user
            user_url(current_backend_user.identity.user)
          else
            root_url
          end
    link_to(text, url)
  end

  def link_to_backend_user_page(text, options={})
    url = if current_backend_user
            send("#{current_backend_user.class.name.underscore}_path", current_identity.backend_user_id)
          else
            root_url
          end
    link_to(text, url)
  end
end
