Rails.application.routes.draw do
  root to: "toys#index"

  resources :toys
  resources :users
  resources :user_sessions

  get 'login' => 'user_sessions#new', as: :login
  post 'logout' => 'user_sessions#destroy', as: :logout
end
