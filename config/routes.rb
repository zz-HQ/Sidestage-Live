Airmusic::Application.routes.draw do

  ## App
  scope '(:locale)', locale: Regexp.new(I18n.available_locales.map(&:to_s).join('|'))   do
    root to: "home#index"

    post 'create_subscriber', to: "home#create_subscriber", as: "create_subscriber"

    post 'change_currency', to: 'home#change_currency', as: :change_currency
    post 'change_locale', to: 'home#change_locale', as: :change_locale
  
    devise_for :users, controllers: { registrations: "registrations" }
    
    resources :artists, :only => [:new, :create, :index, :show]
    
    namespace :account do
      resources :profiles
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
      root 'conversations#index'
    end
    
    get 'terms-of-service', to: "pages#terms", as: "terms"
    get 'privacy-policy', to: "pages#privacy", as: "privacy"
  end
  
  get '/:locale', :to => "home#index", :constraints => { :locale => /\w{2}/ }
  

end
