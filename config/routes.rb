Rails.application.routes.draw do
  devise_for :users, :controllers => { :registrations => "registrations"}
  root to: 'pages#home'
  get '/mon-profil', to: 'users#profile', as: :profile
  resources :lessons, only: [:index, :new, :create]  do
    resources :messages, only: [:index, :create]
  end
  get 'change-lesson-public/:id', to: 'lessons#change_lesson_public', as: :change_lesson_public
  get 'public-lessons', to: 'lessons#public_lessons', as: :public_lessons
  get 'lesson-done/:id', to: 'lessons#lesson_done', as: :lesson_done
  get 'lesson-not-done/:id', to: 'lessons#lesson_not_done', as: :lesson_not_done
  patch 'cancel-lesson/:id', to: 'lessons#cancel', as: :cancel_lesson

  get 'be-coach/:id', to: 'lessons#be_coach', as: :be_coach
  get 'be-coach-via-email/:lesson_id/users/:user_id', to: 'lessons#be_coach_via_mail', as: :be_coach_via_mail

  get 'dashboard', to: 'dashboards#show'
  patch '/admin', to: "users#become_admin", as: :become_admin
  patch '/undo-admin/:id', to: "users#undo_admin", as: :undo_admin
  resources :locations, only: [:create]
  resources :partners, only: [:create]
  resources :friendships, only: :index
  resources :friend_requests, only: [:create, :update]
  resources :bookings, only: [:index, :create, :destroy]
  post 'lessons/:lesson_id/coach-messages', to: 'messages#coach_message', as: :coach_messages
  get 'accept-invitation/:booking_id', to: "bookings#accept_invitation", as: :accept_invitation
  get 'public-lesson-booking/:lesson_id', to: "bookings#public_lesson_booking", as: :public_lesson_booking

  get 'sign-up-coach', to: "coachs#sign_up", as: :coach_sign_up
  get 'sportive-profile/:id', to:'users#sportive_profile', as: :sportive_profile
  get 'faq', to: "pages#faq", as: :faq
  get 'forum', to: "pages#forum", as: :forum
  get 'abonnements', to: "pages#offers", as: :offers
  patch '/coach-validation', to: "users#coach_validation", as: :coach_validation
  resources :subjects, only: [:new, :create, :show] do
    resources :answers, only: [:create]
  end
  resources :pack_orders, only: [:show, :create] do
    resources :payments, only: :new
  end
  resources :customer_portal_sessions, only: [:create]
  mount StripeEvent::Engine, at: '/stripe-webhooks'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
