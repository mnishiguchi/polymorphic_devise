Rails.application.routes.draw do

  devise_for :identities, controllers: {
    sessions:           "identities/sessions",
    passwords:          "identities/passwords",
    registrations:      "identities/registrations",
    confirmations:      "identities/confirmations",
    omniauth_callbacks: "identities/omniauth_callbacks"
  }

  # Admin and business users
  resources :admins, only: [:show]
  resources :account_executives, only: [:show]
  resources :management_clients, only: [:show]
  resources :property_clients, only: [:show]

  root to: "static_pages#home"

  # For viewing delivered emails in development environment.
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
