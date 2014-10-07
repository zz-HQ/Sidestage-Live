require 'spec_helper'


RSpec.configure do |config|
  #Capybara.javascript_driver = :webkit

  #config.include Features::AcceptanceHelpers, type: :feature

  config.use_transactional_fixtures = false

  config.before(:suite) do
   DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
  
  config.before(:each, :type => :feature) do
    FactoryGirl.create(:us_dollar)  
    FactoryGirl.create(:euro)
  end  


end