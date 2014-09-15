class BalancedWorker
  include Sidekiq::Worker
  
  def perform(method, id)
    send(method, id)
  end

  def delete_customer(id)
    return if id.blank?
    begin
      Balanced::Customer.fetch("/customers/#{id}").unstore
    rescue Balanced::NotFound => e
      #wrong param or already deleted
    end
  end

  def delete_bank_account(id)
    return if id.blank?
    begin
      Balanced::BankAccount.fetch("/bank_accounts/#{id}").unstore
    rescue Balanced::NotFound => e
      #wrong param or already deleted
    end
  end
  
  def delete_card(id)
    return if id.blank?
    begin
      Balanced::Card.fetch("/cards/#{id}").unstore
    rescue Balanced::NotFound => e
      #wrong param or already deleted
    end
  end
  
end