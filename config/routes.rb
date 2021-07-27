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
  resources :bookings, only: [:index, :create] do
    resources :messages, only: :create
  end
  get 'accept-invitation/:booking_id', to: "bookings#accept_invitation", as: :accept_invitation


  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
