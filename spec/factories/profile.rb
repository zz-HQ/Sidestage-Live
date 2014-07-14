FactoryGirl.define do
  
  factory :profile do
    price 123
    title "TL"
    about "about"
    currency "EUR"
    published true
    after(:build) {|profile| profile.genres = [create(:genre)]}
    user
    
    factory :gaga do
      name "gaga"
      location "california"      
      price 200      
    end
    
    factory :shakira do
      name "shakira"
      location "mexico"
      price 300
    end
    
    factory :unpublished do
      name "unpublished"
      location "mexico"
      price 300
      published false
    end
    
    
  end
  
end