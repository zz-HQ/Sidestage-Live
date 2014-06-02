class CreateDeals < ActiveRecord::Migration
  def change
    create_table :deals do |t|
      t.integer :conversation_id
      t.integer :message_id
      t.integer :profile_id
      t.integer :artist_id
      t.integer :customer_id
      t.datetime :artist_accepted_at
      t.datetime :customer_accepted_at
      t.integer :price
      t.datetime :start_at
      t.boolean :offer
      t.text :note
      t.timestamps
    end
    add_index :deals, :conversation_id
    add_index :deals, :artist_id
    add_index :deals, :customer_id
  end
end
