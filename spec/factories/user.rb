FactoryGirl.define do

  factory :user do
    first_name "user FN"
    last_name "user LN"
    email "user@example.com"
    password "12345678"
    confirmed_at Time.now


    factory :quentin do
      email "quentin@example.com"
    end

    factory :bob do
      email "bob@example.com"
    end

  end
  
  
end