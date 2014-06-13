module ApplicationHelper

  def display_base_errors resource
    return '' if (resource.errors.empty?) or (resource.errors[:base].empty?)
    messages = resource.errors[:base].map { |msg| content_tag(:p, msg) }.join
    html = <<-HTML
    <div class="alert alert-error alert-block">
      <button type="button" class="close" data-dismiss="alert">&#215;</button>
      #{messages}
    </div>
    HTML
    html.html_safe
  end
  
  def price_in_current_currency(price, price_currency)
    return price if @current_currency.nil?
    CurrencyConverterService.convert(price, price_currency, @current_currency.name)
  end
  
  def localized_price(price, price_currency)
    number_to_currency(price_in_current_currency(price, price_currency), unit: @current_currency.symbol)
  end
  
  def available_locations
    ["Berlin", "London"]
  end
  
  def available_locales
    {
      de: "Deutsch",
      en: "English"
    }
  end

  def link_or_login(path)
    user_signed_in? ? path : new_user_session_path(return_to: request.url)
  end
  
  def artist_contactable?(artist)
    !current_user || (current_user.id != artist.id)
  end
  
end
