Rails.application.routes.draw do
  root to: "toys#index"

  resources :toys
  resources :user_sessions
  resources :users do
    resources :cats
  end
  resources :histories

  get 'login' => 'user_sessions#new', as: :login
  post 'logout' => 'user_sessions#destroy', as: :logout
end
