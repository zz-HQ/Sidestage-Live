module Profile::Payoutable
  extend ActiveSupport::Concern

  
  included do

    store :payout, accessors: [ :iban, :bic, :routing_number, :account_number, :payout_name, :payout_state, :payout_city, :payout_postal_code, :payout_street, :payout_street_2, :payout_country ]
    
  end
  
  def uk?
    country_short == "UK"
  end
  
  def usa?
    country_short == "US"
  end
  
end