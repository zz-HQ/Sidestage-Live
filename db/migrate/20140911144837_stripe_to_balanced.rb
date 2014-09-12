class StripeToBalanced < ActiveRecord::Migration
  def change
    rename_column :users, :stripe_customer_id, :balanced_customer_id
    rename_column :users, :stripe_card_id, :balanced_card_id
    
    rename_column :deals, :stripe_charge_id, :balanced_debit_id

    add_column :profiles, :balanced_customer_id, :string
  end
end
