class AddStripeFields < ActiveRecord::Migration
  def change
    add_column :users, :stripe_customer_id, :string

    add_column :deals, :stripe_charge_id, :string
    add_column :deals, :charged_price, :integer
    add_column :deals, :currency, :string
  end
end
