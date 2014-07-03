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
      price 200      
    end
    
    factory :shakira do
      name "shakira"
      price 300
    end
    
  end
  
end