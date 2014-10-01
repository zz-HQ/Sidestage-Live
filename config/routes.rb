require 'sidekiq/web'

Airmusic::Application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  
  devise_for :users, controllers: { sessions: "authentication/sessions", registrations: "authentication/registrations", confirmations: "authentication/confirmations", :omniauth_callbacks => "authentication/omniauth_callbacks" }
  
  scope '(:locale)', locale: Regexp.new(I18n.available_locales.map(&:to_s).join('|'))   do

    root to: "home#homepage"

    post 'create_subscriber', to: "home#create_subscriber", as: "create_subscriber"

    post 'change_currency', to: 'home#change_currency', as: :change_currency
    post 'change_locale', to: 'home#change_locale', as: :change_locale

    resources :match_mes, path: 'match_me' do
      collection do
        get :thanks
        match 'location', to: 'match_mes#location', via: :all  
      end
    end
    
    resources :artists, :only => [:new, :create, :index, :show]
    
    namespace :account do

      concern :paginatable do
        get '(page/:page)', :action => :index, :on => :collection, :as => ''
      end

      resource :mobile_numbers, only: [:show, :destroy, :update] do
        patch :confirm
      end
      
      resource :personal do
        collection do
          delete :destroy_avatar
          patch :upload_avatar
          get :skip_payment
          delete :remove_card
          delete :remove_bank_account
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
      resource :profile_completion do
        collection do
          match 'phone', to: 'profile_completion#phone', via: :get
          match 'basics', to: 'profile_completion#basics', via: :all          
          match 'pricing', to: 'profile_completion#pricing', via: :all            
          match 'description', to: 'profile_completion#description', via: :all                    
        end
      end
      resource :profile do
        member do
          get :preview
          put :toggle
          patch :soundcloud
          patch :youtube
          put :remove_soundcloud
          put :remove_youtube
          match 'description', to: 'profiles#description', via: :all
          match 'basics', to: 'profiles#basics', via: :all
          match 'pricing', to: 'profiles#pricing', via: :all
          match 'payment', to: 'profiles#payment', via: :all
        end
        resources :pictures
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

      resources :conversations do 
        get :archived, on: :collection
        put :archive, on: :member
        resources :conversation_messages, :concerns => :paginatable
      end
      resources :payment_details

      
      root 'personals#complete'
    end

    resources :city_launches
    get 'cancellations', to: "pages#cancellations", as: "cancellations"
    get 'faq', to: "pages#faq", as: "faq"
    get 'press', to: "pages#press", as: "press"
    get 'terms-of-service', to: "pages#terms", as: "terms"
    get 'privacy-policy', to: "pages#privacy", as: "privacy"
    get 'jobs', to: "pages#jobs", as: "jobs"
    get 'index', to: "home#index", as: "homepage"    
    get 'home', to: "home#homepage", as: "home"    
    put :accept_cookies, to: "home#accept_cookies", as: "accept_cookies"
    
    namespace :admin do
      root to: "dashboard#index"
      resources :profiles do
        member do
          put :toggle_admin_disabled          
          put :toggle
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
    end
    
  end

  match "/404", :to => "errors#not_found", via: :get
  match "/500", :to => "errors#internal_error", via: :get  
  match "/422", :to => "errors#unacceptable", via: :get  
  
  get '/:locale', :to => "home#index", :constraints => { :locale => /\w{2}/ }
  
end
