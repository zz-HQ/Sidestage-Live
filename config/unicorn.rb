run_sidekiq_in_this_thread = ["sidestaging.herokuapp.com"].include?(ENV['APP_HOST']) #staging

worker_processes Integer(ENV["WEB_CONCURRENCY"] || 3)
timeout 30
preload_app true
listen ENV['PORT'], :backlog => Integer(ENV['UNICORN_BACKLOG'] || 200)

#staging
if run_sidekiq_in_this_thread
  @sidekiq_pid = nil
end

# config/unicorn.rb
before_fork do |server, worker|
  # other settings
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
  end
  
  #staging
  if run_sidekiq_in_this_thread
    @sidekiq_pid ||= spawn("bundle exec sidekiq -c 2")
    Rails.logger.info('Spawned sidekiq #{@sidekiq_pid}')
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
