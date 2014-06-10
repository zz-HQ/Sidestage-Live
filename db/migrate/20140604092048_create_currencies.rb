class CreateCurrencies < ActiveRecord::Migration
  def change
    create_table :currencies do |t|
      t.string :name
      t.string :symbol
      t.timestamps
    end
    add_index :currencies, :name
    { USD: "$", EUR: "€" }.each do |n, s|
      Currency.create name: n, symbol: s
    end
  end
end
