class CurrencyService

  #
  # Constants
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  YAHOO_URL = "https://query.yahooapis.com/v1/public/yql"

  #
  # New
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  def initialize
    env = "store://datatables.org/alltableswithkeys"
    format = "json"
    q = "select * from yahoo.finance.xchange where pair in ('SIDESTAGE_CURRENCIES')"
    @uri = "#{YAHOO_URL}?env=#{env}&format=#{format}&q=#{q}"
  end
  
  #
  # Class Methods
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  def self.update_all_rates
    Currency.all.each do |from_currency|

      Currency.where("id != ?", from_currency.id).each do |to_currency|
        service = CurrencyService.new
        rate = service.get_yahoo_rate(from_currency.name, to_currency.name)
        service.update_currency_rate(from_currency, to_currency, rate)
      end
    end
  end
  
  #
  # Instance Methods
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  def update_currency_rate(from_currency, to_currency, rate)
    currency_rate = CurrencyRate.where(rate_from: from_currency.name, rate_to: to_currency.name).first || CurrencyRate.new
    currency_rate.rate_from = from_currency.name
    currency_rate.rate_to = to_currency.name
    currency_rate.rate = rate["Rate"].to_f
    currency_rate.ask = rate["Ask"].to_f
    currency_rate.bid = rate["Bid"].to_f
    currency_rate.currency_id = from_currency.id
    currency_rate.save
  end
  
  def get_yahoo_rate(from, to)
    response = JSON.load(open(URI.encode(@uri.gsub("SIDESTAGE_CURRENCIES", "#{from}#{to}"))))
    response["query"]["results"]["rate"]
  end
  
end
