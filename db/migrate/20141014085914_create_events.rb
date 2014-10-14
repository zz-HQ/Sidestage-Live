class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :user_id
      t.string :event_day
      t.string :event_time
      t.string :music_type
      t.string :postal_code
      t.string :balanced_charge_id
      t.integer :charged_price
      t.string :currency
      t.text :address
      t.string :phone
      t.text :additionals
      t.timestamps
    end
  end
end
