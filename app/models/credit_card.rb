class CreditCard
  include ActiveModel::Model

  #
  # Attributes
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  attr_accessor :balanced_customer, :balanced_card, :number, :exp_month, :exp_year, :name, :brand, :error

  #
  # Class Methods
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  def initialize(customer, card)
    @name = card.bank_name
    @number = card.number
    @brand = card.brand
    @exp_month = card.expiration_month
    @exp_year = card.expiration_year
  end
  
  def self.from_balanced_customer(customer)
    CreditCard.new customer, customer.cards.first
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
  
end
