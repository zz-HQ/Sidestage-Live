FactoryGirl.define do
  
  factory :profile do
    price 123
    tagline "TL"
    about "about"
    after(:build) {|profile| profile.genres = [create(:genre)]}
    user 
  end
  
end