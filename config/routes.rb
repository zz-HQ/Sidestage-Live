require 'sidekiq/web'

Airmusic::Application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'



  devise_for :users, controllers: { sessions: "authentication/sessions", registrations: "authentication/registrations", confirmations: "authentication/confirmations", :omniauth_callbacks => "authentication/omniauth_callbacks" }

  scope '(:locale)', locale: Regexp.new(I18n.available_locales.map(&:to_s).join('|'))   do

    root to: "home#homepage"

    post 'create_subscriber', to: "home#create_subscriber", as: "create_subscriber"

    post 'change_currency', to: 'home#change_currency', as: :change_currency
    post 'change_locale', to: 'home#change_locale', as: :change_locale

    resources :events do
      member do
        put :accept
        put :reject
      end
      collection do
        get :thanks
      end
    end
    resource :forward do
      get ":token/event_invitation", to: "forward#event_invitation", as: :event_invitation
      get "facebook_auth", to: "forward#facebook_auth", as: :facebook_auth
    end

    resources :match_mes, path: 'match_me' do
      collection do
        get :thanks
        match 'location', to: 'match_mes#location', via: :all
      end
    end

    resources :express_bookings, path: :x do
      collection do
        post :sign_up
      end
    end
    resources :artists, only: [:index, :show]
    resources :profiles, only: [:new, :create]
    namespace :account do

      concern :paginatable do
        get '(page/:page)', :action => :index, :on => :collection, :as => ''
      end

      resources :share_profiles

      resource :mobile_numbers, only: [:show, :destroy, :update] do
        patch :confirm
      end

      resources :host_events do
        member do
          match 'payment', to: 'host_events#payment', via: :all, as: :payment
          match 'invite_friends', to: 'host_events#invite_friends', via: :all, as: :invite_friends
        end
        match 'confirmation/:id', to: 'host_events#confirmation', via: :all, as: :confirmation, on: :collection
      end

      resource :personal do
        collection do
          delete :destroy_avatar
          patch :upload_avatar
          get :skip_payment
          delete :remove_card
          delete :remove_bank_account
          put :resend_confirmation
          match 'bank_details', to: 'personals#bank_details', via: :all
          match 'payment_details', to: 'personals#payment_details', via: :all
          match 'password', to: 'personals#password', via: :all
          match 'complete', to: 'personals#complete', via: :all
          match 'complete_payment', to: 'personals#complete_payment', via: :all
        end
      end
      resource :dashboard, controller: :dashboard do
        match '', to: 'dashboard#index', via: :get
      end
      resource :profile do
        member do
          get :preview
          put :toggle
          put :remove_soundcloud
          put :remove_youtube
          delete :destroy_avatar
          match 'style', to: 'profiles#style', via: :all
          match 'geo', to: 'profiles#geo', via: :all
          match 'pricing', to: 'profiles#pricing', via: :all
          match 'avatar', to: 'profiles#avatar', via: :all
          match 'description', to: 'profiles#description', via: :all
          match 'music', to: 'profiles#music', via: :all
          match 'payment', to: 'profiles#payment', via: :all
        end
        resources :pictures do
          post :sort, on: :member
        end
      end

      resources :profiles, only: [] do
        resources :reviews, only: [:new, :create]
      end

      resources :messages
      resources :bookings, only: [:index]
      resources :offers, only: [:create, :new]
      resources :deals, except: [:destroy] do
        post :double_check, on: :collection
        member do
          put :cancel
          put :revert
          put :confirm
          put :decline
          put :accept
          put :reject
          patch :offer
        end
      end
      resources :coupons, only: [:apply_on_deal, :apply_on_profile] do
        post 'apply_on_profile/:profile_id', to: 'coupons#apply_on_profile', on: :collection, as: :apply_on_profile
        patch 'apply_on_deal/:deal_id', to: 'coupons#apply_on_deal', on: :collection, as: :apply_on_deal
        post 'apply_on_event', to: 'coupons#apply_on_event', on: :collection, as: :apply_on_event
      end
      resources :conversations do
        get :archived, on: :collection
        put :archive, on: :member
        resources :conversation_messages, :concerns => :paginatable
      end
      resources :payment_details


      root 'personals#complete'
    end

    resources :city_launches

    namespace :admin do

      root to: "dashboard#index"
      get :global_search, to: 'dashboard#global_search', as: :global_search

      resources :profiles do
        member do
          put :toggle_admin_disabled
          put :toggle_featured
          put :toggle
          put :tags
        end
      end
      resources :conversations do
        resources :messages
      end
      resources :deals do
        member do
          put :toggle_payout
        end
      end
      resources :search_queries
      resources :users do
        member do
          get :backdoor
          put :confirm
          put :toggle_verification
        end
      end
      resources :coupons do
        member do
          put :toggle_activation
        end
      end

    end

    get 'share_profile/:slug', to: "pages#share_profile_by_email", as: "share"
    get 'faq', to: "pages#faq", as: "faq"
    get 'cancellations', to: "pages#cancellations", as: "cancellations"
    get 'privacy-policy', to: "pages#privacy", as: "privacy"
    get 'terms-of-service', to: "pages#terms", as: "terms"

  end

  get 'press', to: "pages#press", as: "press"
  get 'jobs', to: "pages#jobs", as: "jobs"
  get 'index', to: "home#index", as: "homepage"
  get 'home', to: "home#homepage", as: "home"
  put :accept_cookies, to: "home#accept_cookies", as: "accept_cookies"

  get ':short_location',
    to: 'artists#index',
    constraints: lambda { |request|
      request.params["short_location"].to_s.downcase.in?(AVAILABLE_LOCATIONS.map(&:last).map { |l| l[:short].downcase })
  }, as: :short_location

  match "/404", :to => "errors#not_found", via: :get
  match "/500", :to => "errors#internal_error", via: :get
  match "/422", :to => "errors#unacceptable", via: :get

  get '/:locale', :to => "home#index", :constraints => { :locale => /\w{2}/ }

end
