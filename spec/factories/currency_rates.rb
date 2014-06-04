FactoryGirl.define do
  factory :currency_rate do
    
    factory :eur_usd do
      rate 1.39
      rate_from "EUR"
      rate_to "USD"
    end

    factory :usd_eur do
      rate 0.76
      rate_from "USD"
      rate_to "EUR"
    end
    
    
  end
end
