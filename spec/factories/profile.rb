FactoryGirl.define do
  
  factory :profile do
    price 123
    title "TL"
    about "about"
    currency "EUR"
    after(:build) {|profile| profile.genres = [create(:genre)]}
    user 
  end
  
end