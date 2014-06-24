module Surcharge
  extend ActiveSupport::Concern
  
  included do
  end
  
  
  def price_with_surcharge_in_cents
    price_with_surcharge * 100
  end
  
    
  def price_with_surcharge
    return price unless ENV["surcharge"].present?
    (price + surcharge).round
  end
  
  def surcharge
    price * (ENV["surcharge"].to_i / 100.0)
  end
    
  
end