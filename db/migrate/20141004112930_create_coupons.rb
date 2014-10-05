class CreateCoupons < ActiveRecord::Migration
  def change
    create_table :coupons do |t|
      t.datetime :expires_at
      t.string :code
      t.text :description
      t.integer :amount
      t.string :currency
      t.boolean :active, default: false
      t.timestamps
    end
  end
end
