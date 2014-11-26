source 'https://rubygems.org'
ruby '2.0.0'


# Backend
gem 'rails', '~> 4.1.5'
gem 'devise'
gem 'mysql2'
gem 'inherited_resources'
gem 'jbuilder', '~> 1.2'
gem 'globalize', '~> 4.0.1'
gem 'gibbon' # Handles Mailchimp integration
gem 'browser'
gem 'balanced'
gem 'omniauth-facebook'
gem 'aasm'
gem 'friendly_id', '~> 5.0.0'
gem 'sinatra', '>= 1.3.0', :require => nil
gem 'sidekiq'
gem 'twilio-ruby', '~> 3.11'
gem 'rotp', '2.0'
gem 'graticule'
gem 'acts-as-taggable-on', '~> 3.4'

# Image Processing
gem 'carrierwave'
gem 'mini_magick'
gem 'fog', '1.24.0'
gem 'unf' # resolves fog errors


# Frontend
gem 'simple_form', '3.0.3'
gem 'turbolinks'
gem 'compass-rails', '~> 1.1.7'
gem 'sass-rails', '4.0.3'
gem 'compass-rgbapng', require: 'rgbapng'
gem 'ceaser-easing'
gem 'jquery-rails', '3.1.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'bourbon'
gem 'neat'
gem 'asset_sync'

gem 'jquery-fileupload-rails'
gem 'kaminari'

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

group :test do
  gem 'factory_girl_rails'
  gem 'rspec-rails', '~> 3.0.0'
  gem 'sms-spec'
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'database_cleaner'
end
