FactoryGirl.define do
  
  factory :deal do
    start_at Time.now
    current_user factory: :quentin
    association :profile, factory: :profile
    association :customer, factory: :quentin
  end
  
end
