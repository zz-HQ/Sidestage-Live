FactoryGirl.define do
  
  factory :deal do
    start_at Time.now
    currency "EUR"
    current_user factory: :quentin
    association :profile, factory: :profile
    association :customer, factory: :quentin

    factory :requested_deal do
      state "requested"
      price 124
      current_user factory: :quentin
      association :profile, factory: :profile
      association :customer, factory: :quentin    
    end

    factory :confirmed_deal do
      state "confirmed"
      price 124
      current_user factory: :quentin
      association :profile, factory: :profile
      association :customer, factory: :quentin    
    end
  
    factory :offered_deal do
      state "offered"
      price 124
      current_user factory: :quentin
      association :profile, factory: :profile
      association :customer, factory: :quentin    
    end
    
    factory :proposed_deal do
      state "proposed"
      price 124
    end

  end
    
end
