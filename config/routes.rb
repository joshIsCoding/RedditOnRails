Rails.application.routes.draw do
  root 'home#index'
  resources :users, only: [:create]
  resource :session, only: [:create, :destroy]
  resources :subs do
    resources :posts, only: :new
  end
  resources :posts, except: [:index, :new] do
    member do
      post "upvote"
      post "downvote"
    end
  end
  resources :post_subs, only: [:destroy]
  resources :comments, only: [:show, :create, :destroy] do
    member do
      post "upvote", to: "comments#upvote"
      post "downvote", to: "comments#downvote"
    end
  end
  get "register", to: "users#new"
  get "login", to: "sessions#new"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
