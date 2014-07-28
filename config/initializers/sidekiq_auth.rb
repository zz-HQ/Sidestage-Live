# # -*- encoding : utf-8 -*-
require 'sidekiq/web'

unless Rails.env.development?
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == 'admin' && password == 'forthewin'
  end
end
