module Priceable
  extend ActiveSupport::Concern
  
  included do
  end
  
  
  def price_before_type_cast
    price
  end
  
  def price
    p = read_attribute(:price)
    p.nil? ? p : (p.to_i / 100.0)
  end
  
  def price=(val)
    write_attribute(:price, val.to_f * 100)
  end
  
  def price_in_cents
    read_attribute(:price).to_i
  end  
  
end