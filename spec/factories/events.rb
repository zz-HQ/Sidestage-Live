FactoryGirl.define do
  
  factory :event do    
    association :user, factory: :user
    event_at Time.now
  end
  
end