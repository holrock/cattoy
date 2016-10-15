Rails.application.routes.draw do
  root to: "toys#index"

  resources :toys
  resources :users
end
