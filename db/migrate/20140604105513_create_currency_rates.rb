class CreateCurrencyRates < ActiveRecord::Migration
  def up
    create_table :currency_rates do |t|
      t.integer :currency_id
      t.string :rate_from
      t.string :rate_to
      t.float :rate
      t.float :ask
      t.float :bid
      t.timestamps
    end
    add_index :currency_rates, :currency_id
    add_index :currency_rates, [:rate_from, :rate_to]
    
    add_column :users, :currency, :string
    remove_column :conversations, :subject
    remove_column :messages, :subject
  end
  
  def down
    add_column :messages, :subject, :string    
    add_column :conversations, :subject, :string        
    remove_column :users, :currency
    drop_table :currency_rates
  end
  
end
