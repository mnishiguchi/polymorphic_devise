Rails.application.routes.draw do

  root to: "static_pages#home"

  # Login
  get    "/login",   to: "sessions#new"
  post   "/login",   to: "sessions#create"
  delete "/logout",  to: "sessions#destroy"

  # General users
  get    "/signup",  to: "users#new"
  resources :users

  # Admin and business users
  resources :admins, only: [:show]
  resources :account_executives, only: [:show]
  resources :management_clients, only: [:show]
  resources :property_clients, only: [:show]

  # # Omniauth
  get '/auth/:provider/callback', to: 'sessions#omniauth_callback'
end
