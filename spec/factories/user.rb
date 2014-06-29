FactoryGirl.define do

  factory :user do
    first_name "user FN"    
    last_name "user LN"
    unread_message_counter 0
    sequence :email do |n|
      "user#{n}@example.com"
    end
    password "12345678"
    confirmed_at Time.now


    factory :quentin do
      first_name "quentin"
      stripe_customer_id "quentin_123"
      stripe_card_id "quentin_123"
    end

    factory :bob do
      first_name "bob"
      stripe_customer_id "bob_123"
      stripe_card_id "bob_123"
    end
    
    factory :artist do
      first_name "artist"      
      stripe_customer_id "artist_123"
      stripe_card_id "artist_123"
    end
    
    factory :customer do
      first_name "customer"      
      stripe_customer_id nil
    end

  end
  
  
end