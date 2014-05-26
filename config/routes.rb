Airmusic::Application.routes.draw do
  
  root :to => "home#index"

  devise_for :users
  
  resources :artists
  
  namespace :account do
    resources :profiles
    resources :messages
  end

end
