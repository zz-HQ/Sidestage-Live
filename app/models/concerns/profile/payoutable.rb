module Profile::Payoutable
  extend ActiveSupport::Concern

  
  included do
    attr_accessor :balanced_token
    
    store :payout, accessors: [ :iban, :bic, :routing_number, :account_number, :payout_name, :payout_address, :payout_state, :payout_city, :payout_postal_code, :payout_street, :payout_street_2, :payout_country ]
    
    before_save :upload_to_payment_gateway
    
    after_destroy :delete_balanced_bank_account
    
  end
  
  def uk?
    country_short == "UK"
  end
  
  def usa?
    country_short == "US"
  end
  
  def bankee_address
    [payout_street, payout_street_2, payout_postal_code, payout_city, payout_state].compact.join(" ")
  end
  
  def balanced_payoutable?
    balanced_bank_account_id.present?
  end
  
  def destroy_balanced_bank_account!
    if unstore_balanced_bank_account
      update_attributes routing_number: nil, account_number: nil, balanced_bank_account_id: nil
    end
  end
  
  #
  # Private
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #  
  
  private
  
  def upload_to_payment_gateway
    if usa? && payout_changed? && balanced_token.present?
      unless balanced_payoutable?
        balanced_customer = user.retrieve_balanced_customer || user.create_balanced_customer
        bank_account = fetch_balanced_bank_account(balanced_token)
        self.balanced_bank_account_id = bank_account.id
        assign_bank_account_to_balanced_customer(balanced_customer, bank_account) if balanced_customer.present?
      end
    end
  end
  
  def unstore_balanced_bank_account
    begin
      fetch_balanced_bank_account(balanced_bank_account_id).unstore
      return true
    rescue Balanced::NotFound => e
      return true
    rescue Balanced::Error => e
      User.where(id: user_id).update_all(error_log: e.inspect)
    end
  end
  
  def fetch_balanced_bank_account(id)
    Balanced::BankAccount.fetch("/bank_accounts/#{id}")
  end

  def assign_bank_account_to_balanced_customer(balanced_customer, balanced_bank_account)
    begin
      balanced_bank_account.associate_to_customer(balanced_customer.href)
      return true
    rescue Balanced::Error => e
      User.where(id: user_id).update_all(error_log: e.inspect)
      errors.add :balanced_bank_account_id, e.extras.values.join(",")
    end
    return false
  end  
  
  def delete_balanced_bank_account
    BalancedWorker.perform_async(:delete_bank_account, balanced_bank_account_id)
  end
  
end