class AddBalancedBankCreditIdToDeals < ActiveRecord::Migration
  def change
    add_column :deals, :balanced_credit_id, :string
  end
end
