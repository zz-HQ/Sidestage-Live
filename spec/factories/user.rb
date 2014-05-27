FactoryGirl.define do

  factory :user do
    first_name "user FN"
    last_name "user LN"
    sequence :email do |n|
      "user#{n}@example.com"
    end
    password "12345678"
    confirmed_at Time.now


    factory :quentin do
      email "quentin@example.com"
    end

    factory :bob do
      email "bob@example.com"
    end
    
    factory :artist do
      email "artist@example.com"
    end
    
    factory :customer do
      email "customer@example.com"
    end

  end
  
  
end