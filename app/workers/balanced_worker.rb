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
  
  def payout_deal(deal_id)
    deal = Deal.where(id: deal_id).first
    return if deal.nil? || deal.profile.nil? || deal.paid_out? || !deal.profile.balanced_payoutable?
    bank_account = Balanced::BankAccount.fetch("/bank_accounts/#{deal.profile.balanced_bank_account_id}")
    credit = bank_account.credit(amount: deal.dollar_price_in_cents, appears_on_statement_as: "Sidestage")
    Deal.where(id: deal.id).update_all(balanced_credit_id: credit.id, paid_out: true)
    deal.credit_on_the_way
  end
  
end