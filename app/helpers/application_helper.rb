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
  
  def sorty(column, options = {})
    options = { label: column.to_s.humanize.titleize }.merge(options)
    query = params.merge({
      column: column,
      order: (params[:order].eql?('asc') ? 'desc' : 'asc')
    })
    class_name = params[:column].eql?(column.to_s) ? query[:order] : 'asc'
    link_to options[:label], query, class: class_name
  end  
  
  def price_in_current_currency(price, price_currency)
    return price if @current_currency.nil?
    CurrencyConverterService.convert(price, price_currency, @current_currency.name)
  end
  
  def localized_price(price, price_currency)
    unit = @current_currency ? @current_currency.symbol : Rails.configuration.default_currency
    number_to_currency(price_in_current_currency(price, price_currency), unit: unit, precision: 0)
  end
  
  def available_locations
    ["Berlin", "More cities"]
  end
  
  def profile_available_locations
    if user_signed_in?
      if current_user.artist?
        ["Berlin", "London"]
      else
        ["Berlin", "London", "More cities"]
      end
    else
      ["Berlin", "London", "More cities"]
    end
  end

  def available_locales
    {
      de: "Deutsch",
      en: "English"
    }
  end
  
  def content_yield(yielded, default)
    yielded.present? ? yielded : default
  end

  def link_or_login(path)
    user_signed_in? ? path : new_user_session_path(return_to: request.url, format: "html")
  end

  def link_or_signin(path)
    user_signed_in? ? path : new_user_registration_path(return_to: request.url, format: "html")
  end
  
  def artist_contactable?(artist)
    !current_user || (current_user.id != artist.id)
  end
  
end
