class Event < ActiveRecord::Base

  #
  # Attributes
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #

  attr_accessor :balanced_token

  store :additionals, accessors: []

  #
  #
  # Validations
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #  

  validates :user_id, presence: true

  #
  #
  # Private
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #  
  
  private
  
  def charge_user!
    return false unless user.paymentable?
    return true if balanced_charge_id.present?
    begin
      price = 99 * 100
      debit = retrieve_balanced_card.retrieve_balanced_card(user.balanced_card_id).debit(
        :amount => price,
        :appears_on_statement_as => 'Sidestage',
        :description => "#{user.name}"
      )
    update_columns balanced_charge_id: debit.id, charged_price: price
    return true
    rescue Balanced::Error => e
      user.update_column(:error_log, e.inspect) 
      errors.add :balanced_charge_id, e.extras.values.join(",")
      return false
    end
  end

  def make_user_paymentable
    if balanced_token.present?
      user.make_paymentable_by_token(balanced_token)
      errors.add :balanced_token, user.errors.full_messages.first if user.errors.present?
    end
  end
  
end
