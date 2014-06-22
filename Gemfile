source 'https://rubygems.org'
ruby '2.1.0'


# Backend
gem 'rails', '4.1.1'
gem 'devise'
# TODO: Two MYSQL Gems ????
#gem 'mysql'
gem 'mysql2'
gem 'inherited_resources'
gem 'jbuilder', '~> 1.2'
gem 'globalize', '~> 4.0.1'
gem 'gibbon' # Handles Mailchimp integration
gem 'browser'
gem 'stripe', :git => 'https://github.com/stripe/stripe-ruby'
gem 'will_paginate'

# Image Processing
gem 'carrierwave'
gem 'mini_magick'
gem 'fog'
gem 'unf' # resolves fog errors


# Frontend
gem 'simple_form'
gem 'turbolinks'
gem 'sass-rails'
gem 'compass-rails'
gem 'compass-rgbapng', require: 'rgbapng'
gem 'ceaser-easing'
gem 'jquery-rails', '3.1.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'bourbon'
gem 'neat'
gem 'asset_sync'
gem 'jquery-fileupload-rails'
gem 'paper_trail', '~> 3.0.2'
gem 'aasm'

group :production do
  gem 'unicorn'
  gem 'rails_12factor'
  gem 'newrelic_rpm'
end

group :development do
  gem 'figaro'
  gem 'quiet_assets'
  gem 'letter_opener'
  gem 'spring'
  gem 'binding_of_caller'
  gem 'better_errors'
end

group :development, :test do
  gem 'factory_girl_rails'
  gem 'rspec-rails'
end
