class CurrencyConverterService

  #
  # Class Methods
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  def self.convert(price, from_currency, to_currency)
    return price if price.nil? || from_currency.nil? || to_currency.nil? || from_currency == to_currency
    rate = CurrencyRate.from_to(from_currency, to_currency).first
    return price if rate.nil?
    return price * rate.rate
  end
  
  
end