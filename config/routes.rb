Rails.application.routes.draw do
  root to: "toys#index"

  resources :cats
  resources :histories
  resources :toys
  resources :user_sessions
  resources :users
  resources :tags, only: :index

  get 'login' => 'user_sessions#new', as: :login
  post 'logout' => 'user_sessions#destroy', as: :logout
  get '/pages/about', to: 'pages#about'
  get '/pages/usage', to: 'pages#usage'
end
