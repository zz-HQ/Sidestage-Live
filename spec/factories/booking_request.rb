FactoryGirl.define do

  factory :booking_request do
    note "Hallo"
    association :requestor, factory: :customer
    association :artist, factory: :artist
    start_at Time.now
    price 123
  end
  
end