module Priceable
  extend ActiveSupport::Concern
  
  included do
  end
  
  
  def price_in_cents(p=nil)
    (p || price) * 100
  end
  
  def dollar_price_in_cents
    price_in_cents(CurrencyConverterService.convert(price, currency, "USD").round)
  end
   
end