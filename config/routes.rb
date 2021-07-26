Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  get '/mon-profil', to: 'users#profile', as: :profile
  resources :lessons, only: [:new, :create]
  get 'dashboard', to: 'dashboards#show'
  patch '/admin', to: "users#become_admin", as: :become_admin
  patch '/undo-admin/:id', to: "users#undo_admin", as: :undo_admin
  resources :locations, only: [:create]
  resources :friendships, only: :index
  resources :friend_requests, only: [:create, :update]


  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
