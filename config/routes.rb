Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  get '/mon-profil', to: 'users#profile', as: :profile
  resources :lessons, only: [:index, :new, :create]  do
    resources :messages, only: [:index, :create]
  end
  get 'change-lesson-public/:id', to: 'lessons#change_lesson_public', as: :change_lesson_public
  get 'public-lessons', to: 'lessons#public_lessons', as: :public_lessons
  get 'be-coach/:id', to: 'lessons#be_coach', as: :be_coach
  get 'be-coach-via-email/:lesson_id/users/:user_id', to: 'lessons#be_coach_via_mail', as: :be_coach_via_mail

  get 'dashboard', to: 'dashboards#show'
  patch '/admin', to: "users#become_admin", as: :become_admin
  patch '/undo-admin/:id', to: "users#undo_admin", as: :undo_admin
  resources :locations, only: [:create]
  resources :friendships, only: :index
  resources :friend_requests, only: [:create, :update]
  resources :bookings, only: [:index, :create]
  post 'lessons/:lesson_id/coach-messages', to: 'messages#coach_message', as: :coach_messages
  get 'accept-invitation/:booking_id', to: "bookings#accept_invitation", as: :accept_invitation
  get 'public-lesson-booking/:lesson_id', to: "bookings#public_lesson_booking", as: :public_lesson_booking

  get 'sign-up-coach', to: "coachs#sign_up", as: :coach_sign_up
  get 'sportive-profile/:id', to:'users#sportive_profile', as: :sportive_profile
  get 'faq', to: "pages#faq", as: :faq
  get 'forum', to: "pages#forum", as: :forum
  resources :subjects, only: [:new, :create, :show] do
    resources :answers, only: [:create]
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
