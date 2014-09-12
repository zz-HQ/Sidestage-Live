module Surcharge
  extend ActiveSupport::Concern
  
  included do
    def self.surcharge_base
      ENV["surcharge"]
    end 
  end
  
  
  def price_with_surcharge_in_cents
    price_with_surcharge * 100
  end

  def price_in_dollor_with_surcharge_in_cents
    CurrencyConverterService.convert(price_with_surcharge, currency, "USD").round * 100
  end
  
  def price_with_surcharge
    return price unless price.present? && Profile.surcharge_base.present?
    (price + surcharge).round
  end
  
  def surcharge
    price * (Profile.surcharge_base.to_i / 100.0)
  end
   
end