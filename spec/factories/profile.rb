FactoryGirl.define do
  
  factory :profile do
    price 123
    title "TL"
    about "about"
    currency "EUR"
    published_at Time.now
    location "Berlin"
    latitude "52.5167"
    longitude "13.3833"
    youtube "www.youtube.com"
    after(:build) do |profile| 
      profile.genres = [create(:genre)]
    end
    after(:create) do |profile|
      profile.pictures = [FactoryGirl.build(:picture, imageable: profile)]
    end
    
    association :user, factory: :user
    
    factory :gaga do
      name "gaga"
      location "Berlin"      
      price 200      
    end
    
    factory :shakira do
      name "shakira"
      location "Berlin"
      price 300
    end
    
    factory :unpublished do
      name "unpublished"
      location "New York City"
      price 300
      published_at nil
    end
 
    factory :balanced do
      name "balanced"
      routing_number "123445"
      account_number "12222"
      balanced_bank_account_id "4321"
      location "New York City"
      price 300
    end
    
    
  end
  
end