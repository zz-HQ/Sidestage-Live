worker_processes Integer(ENV["WEB_CONCURRENCY"] || 4)
timeout 60
preload_app true
listen ENV['PORT'], :backlog => Integer(ENV['UNICORN_BACKLOG'] || 200)

# config/unicorn.rb
before_fork do |server, worker|
  # other settings
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
  end
end

after_fork do |server, worker|
  # other settings
  if defined?(ActiveRecord::Base)
    config = ActiveRecord::Base.configurations[Rails.env] ||
                Rails.application.config.database_configuration[Rails.env]
    config['reaping_frequency'] = ENV['DB_REAP_FREQ'] || 10 # seconds
    config['pool']            =   ENV['DB_POOL'] || 2
    ActiveRecord::Base.establish_connection(config)
  end
end
