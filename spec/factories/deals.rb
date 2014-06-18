FactoryGirl.define do
  
  factory :deal do
    start_at Time.now    
    association :profile, factory: :profile
    association :customer, factory: :quentin
  end
  
end
