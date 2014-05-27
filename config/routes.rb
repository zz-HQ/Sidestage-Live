Airmusic::Application.routes.draw do
  
  root :to => "home#index"

  devise_for :users
  
  resources :artists
  
  namespace :account do
    resources :profiles
    resources :messages
    
    resources :booking_requests
    
  end

end
