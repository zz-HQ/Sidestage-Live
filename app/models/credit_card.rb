class CreditCard
  include ActiveModel::Model

  #
  # Attributes
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  attr_accessor :stripe_customer, :stripe_card, :last4, :exp_month, :exp_year, :name, :type, :error

  #
  # Class Methods
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  def self.from_stripe_customer(customer)
    card = CreditCard.new stripe_customer: customer, stripe_card: customer.cards.first
    card.name = customer.cards.first.name
    card.last4 = customer.cards.first.last4
    card.type = customer.cards.first.type
    card.exp_month = customer.cards.first.exp_month
    card.exp_year = customer.cards.first.exp_year
    card
  end


  #
  # Instance Methods
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #

  def expiration_human
    "#{I18n.t("date.abbr_month_names")[exp_month.to_i]} #{exp_year}"
  end
  
  def update_attributes(attributes)
    attributes.each do |name, value|
      stripe_card.send("#{name}=", value)
    end
    begin
      stripe_card.save
      return true
    rescue Stripe::StripeError => e
      errors.add :error, e.json_body[:error][:message]
      Rails.logger.info "###########################"
      Rails.logger.info e.inspect
      Rails.logger.info "###########################"
      return false
    end
  end
  
end
