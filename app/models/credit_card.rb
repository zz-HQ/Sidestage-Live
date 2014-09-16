class CreditCard
  include ActiveModel::Model

  #
  # Attributes
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  attr_accessor :balanced_card, :number, :exp_month, :exp_year, :name, :brand, :error

  #
  # Class Methods
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  def initialize(card)
    @name = card.bank_name
    @number = card.number
    @brand = card.brand
    @exp_month = card.expiration_month
    @exp_year = card.expiration_year
    balanced_card = card
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
