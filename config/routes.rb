Rails.application.routes.draw do
  root 'home#index'
  resources :users, only: [:create]
  resource :session, only: [:create, :destroy]
  resources :subs
  get "register", to: "users#new"
  get "login", to: "sessions#new"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
