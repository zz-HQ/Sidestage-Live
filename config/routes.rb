Airmusic::Application.routes.draw do

  scope '(:locale)', locale: Regexp.new(I18n.available_locales.map(&:to_s).join('|'))   do
    root to: "home#index"

    post 'create_subscriber', to: "home#create_subscriber", as: "create_subscriber"

    post 'change_currency', to: 'home#change_currency', as: :change_currency
    post 'change_locale', to: 'home#change_locale', as: :change_locale
  
    devise_for :users, controllers: { sessions: "authentication/sessions", registrations: "authentication/registrations", confirmations: "authentication/confirmations" }
    
    resources :artists, :only => [:new, :create, :index, :show]
    
    namespace :account do
      resource :personal do
        collection do
          match 'complete', to: 'personals#complete', via: :all          
        end
      end
      resource :dashboard, controller: :dashboard do
        match '', to: 'dashboard#index', via: :get
      end
      resources :profiles do
        member do
          get :preview
          put :toggle
          match 'complete', to: 'profiles#complete', via: :all
          match 'pricing', to: 'profiles#pricing', via: :all          
        end
      end
      resources :pictures, only: [:index, :create, :destroy]
      resources :outgoing_messages
      resources :deals do
        member do
          put :accept
          put :confirm
        end
      end
      resources :offers
      resources :booking_requests
      resources :conversations
      resources :payment_details
      
      root 'dashboard#index'
    end

    get 'terms-of-service', to: "pages#terms", as: "terms"
    get 'privacy-policy', to: "pages#privacy", as: "privacy"
    
  end

  
  get '/:locale', :to => "home#index", :constraints => { :locale => /\w{2}/ }
  

end
