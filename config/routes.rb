Rails.application.routes.draw do
  # devise_for :users, :controllers => { :registrations => "registrations"}
  devise_for :users,
            :controllers => { :registrations => 'registrations' },
            :path => 'utilisateur',
            :path_names => {
              :sign_in => 'connexion',
              :sign_up => 'inscription',
              :sign_out => 'deconnexion',
              :password => 'mot-de-passe',
              :edit => 'modifier-mon-profil'
            }

  root to: 'pages#home'
  get '/mon-profil', to: 'users#profile', as: :profile
  get '/mes-reservations', to: 'lessons#index', as: :lessons
  post '/mes-reservations', to: 'lessons#create'
  get '/seance-de-sport-personnalisee', to: 'lessons#new', as: :new_lesson

  resources :lessons, only: []  do
    resources :messages, only: [:index, :create]
  end

  get 'change-lesson-public/:id', to: 'lessons#change_lesson_public', as: :change_lesson_public
  get 'seances-de-sport-a-la-demande', to: 'lessons#public_lessons', as: :public_lessons
  get 'lesson-done/:id', to: 'lessons#lesson_done', as: :lesson_done
  get 'lesson-not-done/:id', to: 'lessons#lesson_not_done', as: :lesson_not_done
  patch 'cancel-lesson/:id', to: 'lessons#cancel', as: :cancel_lesson
  get 'focus-lesson/:id', to: 'lessons#focus_lesson', as: :focus_lesson
  get 'pre-validate-lesson/:id', to: 'lessons#pre_validate_lesson', as: :pre_validate_lesson

  get 'be-coach/:id', to: 'lessons#be_coach', as: :be_coach
  get 'be-coach-via-email/:lesson_id/users/:user_id', to: 'lessons#be_coach_via_mail', as: :be_coach_via_mail

  get 'tableau-de-suivi', to: 'dashboards#show', as: :dashboard
  get 'analytics', to: 'dashboards#analytics', as: :analytics
  get 'export-abonnés', to: 'dashboards#export_number_of_users', as: :export_number_of_users
  get 'export-coach', to: 'dashboards#export_number_of_coachs', as: :export_number_of_coachs
  get 'export-seance-abonnement', to: 'dashboards#export_lessons_sub', as: :export_lessons_sub
  get 'export-seance-credit', to: 'dashboards#export_lessons_credit', as: :export_lessons_credit
  get 'export-taux-remlissage', to: 'dashboards#export_filling_rate', as: :export_filling_rate
  get 'export-seances-effectuees', to: 'dashboards#export_lessons_done_this_year', as: :export_lessons_done_this_year
  get 'export-company-discovers', to: 'dashboards#export_company_discovers', as: :export_company_discovers
  get 'export-users-data', to: 'dashboards#export_users_data', as: :export_users_data
  get 'all-lessons', to: 'dashboards#all_lessons', as: :all_lessons

  patch '/admin', to: "users#become_admin", as: :become_admin
  patch '/undo-admin/:id', to: "users#undo_admin", as: :undo_admin
  get '/desabonnement-newsletter', to: "users#unsubscribe_newsletter", as: :unsubscribe_newsletter
  patch '/utiliser-code-promo/:id', to: "users#use_a_promo_code", as: :use_a_promo_code

  post '/desabonnement-newsletter-reponses', to: "reasons#create", as: :reasons

  resources :locations, only: [:create, :destroy]
  resources :partners, only: [:create]
  # resources :friendships, only: :index
  get 'mes-amis', to: 'friendships#index', as: :friendships
  resources :friend_requests, only: [:create, :update]
  resources :bookings, only: [:index, :create, :destroy]

  post 'lessons/:lesson_id/coach-messages', to: 'messages#coach_message', as: :coach_messages
  get 'accept-invitation/:booking_id', to: "bookings#accept_invitation", as: :accept_invitation
  get 'public-lesson-booking/:lesson_id', to: "bookings#public_lesson_booking", as: :public_lesson_booking
  post 'invitations-par-emails', to: "bookings#create_by_emails", as: :create_by_emails

  get 'inscription-coach', to: "coachs#sign_up", as: :coach_sign_up
  get 'inscription-entreprise', to: "enterprises#sign_up", as: :enterprise_sign_up
  get 'sportive-profile/:id', to:'users#sportive_profile', as: :sportive_profile
  get 'foire-aux-questions', to: "pages#faq", as: :faq
  get 'forum', to: "pages#forum", as: :forum
  get 'nos-tarifs', to: "pages#offers", as: :offers
  get 'a-propos', to: "pages#about", as: :about
  get 'conditions-generales-de-ventes', to: "pages#cgv", as: :cgv
  get 'mentions-legales', to: "pages#legals", as: :legals
  get 'notre-concept', to: "pages#concept", as: :concept
  patch '/coach-validation', to: "users#coach_validation", as: :coach_validation

  resources :subjects, only: [:new, :create, :show] do
    resources :answers, only: [:create]
  end
  resources :pack_orders, only: [:show, :create] do
    resources :payments, only: :new
  end
  resources :customer_portal_sessions, only: [:create]

  post 'nouveau-code-promo', to: "promo_codes#create", as: :promo_codes
  patch 'modifier-code-promo/:id', to: "promo_codes#toggle_active_status", as: :toggle_active_status

  mount StripeEvent::Engine, at: '/stripe-webhooks'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
