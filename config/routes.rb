Rails.application.routes.draw do

  # Authentication
  devise_for :identities,
    controllers: {
      sessions:           "identities/sessions",
      passwords:          "identities/passwords",
      registrations:      "identities/registrations",
      confirmations:      "identities/confirmations",
      omniauth_callbacks: "identities/omniauth_callbacks"
    },
    # https://github.com/plataformatec/devise#configuring-routes
    path: 'auth',
    path_names: { sign_up: 'signup', sign_in: 'login', sign_out: 'logout' }

  # Ask for email address after successful OAuth.
  # NOTE: We use GET and PUT/PATCH for this operation because we need to
  # specify the id for a particulr identity.
  resources :email_confirmations, only: [:show, :update]

  # To demonstarate Pundit authorization
  resources :identities

  # To demonstarate Pundit authorization
  resources :identities

  # Soial profiles
  resources :social_profiles

  # Frontend users
  resources :users

  # Backend users
  resources :admins, only: [:show]
  resources :account_executives, only: [:show]
  resources :management_clients, only: [:show]
  resources :property_clients, only: [:show]

  resource :password_reset, only: [:new, :edit, :update]

  root to: "static_pages#home"

  # For viewing delivered emails in development environment.
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
