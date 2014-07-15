# -*- encoding : utf-8 -*-
redis_uri = Rails.env.development? ? "redis://localhost:6379" : ENV['REDISCLOUD_URL']

Sidekiq.configure_server do |config|
  config.redis = { :url => redis_uri, :namespace => "sidestage:sidekiq:#{Rails.env.first}" }
end

# When in Unicorn, this block needs to go in unicorn's `after_fork` callback:
##### NOT :) Sidekiq.configure_client is in unicorn after_fork

Sidekiq.configure_client do |config|
  config.redis = { :url => redis_uri, :namespace => "sidestage:sidekiq:#{Rails.env.first}" }
end
