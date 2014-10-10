FactoryGirl.define do
  
  factory :deal do
    start_at Time.now
    currency "EUR"
    current_user { customer }
    association :profile, factory: :profile
    association :customer, factory: :quentin

    factory :requested_deal do
      state "requested"
      artist_price 124
      customer_price 150
      current_user { customer }
      association :profile, factory: :profile
      association :customer, factory: :quentin    
    end

    factory :confirmed_deal do
      state "confirmed"
      artist_price 124
      customer_price 150
      current_user { customer }
      association :profile, factory: :profile
      association :customer, factory: :quentin    
    end

    factory :past_confirmed_charged_deal do
      start_at 2.day.ago
      balanced_debit_id "12345"
      state "confirmed"
      artist_price 124
      customer_price 150
      current_user { customer }
      association :profile, factory: :balanced
      association :customer, factory: :quentin    
    end
  
    factory :offered_deal do
      state "offered"
      artist_price 124
      customer_price 150
      current_user { profile.user }
      association :profile, factory: :profile
      association :customer, factory: :quentin    
    end
    
    factory :proposed_deal do
      state "proposed"
      artist_price 124
      customer_price 150
    end

  end
    
end
