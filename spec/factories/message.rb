FactoryGirl.define do
  factory :message do
    body "body"
    current_user factory: :user
    association :sender, factory: :user
    association :receiver, factory: :quentin
        
    factory :user_quentin do
      association :sender, factory: :user
      association :receiver, factory: :quentin
    end

    factory :user_bob do
      association :sender, factory: :user
      association :receiver, factory: :bob
    end

    factory :bob_user do
      association :sender, factory: :bob
      association :receiver, factory: :user
    end
    
    factory :quentin_bob do
      association :sender, factory: :quentin
      association :receiver, factory: :bob
    end
    
    factory :system_message_quentin do
      system_message true
      association :sender, factory: :bob
      association :receiver, factory: :quentin      
    end
        
  end 
end