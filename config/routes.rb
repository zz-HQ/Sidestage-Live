Airmusic::Application.routes.draw do
  
  root to: "home#index"
  post 'create_subscriber', to: "home#create_subscriber", as: "create_subscriber"

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
    root to: "/home#index"
  end

end
