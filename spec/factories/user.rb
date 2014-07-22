FactoryGirl.define do

  factory :user do
    full_name "user LN"
    unread_message_counter 0
    mobile_nr "+4912345678"
    mobile_nr_confirmed_at Time.now
    sequence :email do |n|
      "user#{n}@example.com"
    end
    password "12345678"
    confirmed_at Time.now


    factory :quentin do
      full_name "quentin"
      mobile_nr "+4922345678"
      stripe_customer_id "quentin_123"
      stripe_card_id "quentin_123"
    end

    factory :bob do
      full_name "bob"
      mobile_nr "+4932345678"
      stripe_customer_id "bob_123"
      stripe_card_id "bob_123"
    end
    
    factory :artist do
      full_name "artist"      
      mobile_nr "+4942345678"
      stripe_customer_id "artist_123"
      stripe_card_id "artist_123"
    end
    
    factory :customer do
      mobile_nr "+4952345678"  
      full_name "customer"      
      stripe_customer_id nil
      stripe_card_id nil
    end

  end
  
  
end