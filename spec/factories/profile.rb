FactoryGirl.define do
  
  factory :profile do
    price 123
    title "TL"
    about "about"
    currency "EUR"
    published true
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
      
      published false
    end
    
    
  end
  
end