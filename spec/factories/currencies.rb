# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :currency do
    factory :us_dollar do
      name "USD"
      symbol "$"
    end
    factory :euro do
      name "EUR"
      symbol "€"
    end    
  end
end
