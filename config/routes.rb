Airmusic::Application.routes.draw do
  
  post 'change_currency', to: 'home#change_currency', as: :change_currency
  
  scope '(:locale)', locale: Regexp.new(I18n.available_locales.map(&:to_s).join('|'))   do
  
    devise_for :users  
    
    resources :artists  
    
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
    root 'home#index'
  end
  
  get '/:locale', :to => "home#index", :constraints => { :locale => /\w{2}/ }

end
