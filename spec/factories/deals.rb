FactoryGirl.define do
  
  factory :deal do
    start_at Time.now
    current_user factory: :quentin
    association :profile, factory: :profile
    association :customer, factory: :quentin
  
    factory :offered_deal do
      state "offered"
      price 124
      currency "EUR"
      start_at Time.now
      current_user factory: :quentin
      association :profile, factory: :profile
      association :customer, factory: :quentin    
    end

  end
    
end
