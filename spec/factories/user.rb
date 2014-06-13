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
    end

    factory :bob do
    end
    
    factory :artist do
    end
    
    factory :customer do
    end

  end
  
  
end