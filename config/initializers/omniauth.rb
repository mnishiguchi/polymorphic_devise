Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter,
    Rails.application.secrets.twitter_key,
    Rails.application.secrets.twitter_secret
  provider :facebook,
    Rails.application.secrets.facebook_key,
    Rails.application.secrets.facebook_secret
  provider :google_oauth2,
    Rails.application.secrets.google_oauth2_key,
    Rails.application.secrets.google_oauth2_secret
end
