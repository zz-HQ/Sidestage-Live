class CreateBookingOffers < ActiveRecord::Migration
  def change
    create_table :booking_offers do |t|
      t.integer :booking_request_id
      t.integer :requestor_id
      t.integer :artist_id
      t.integer :price
      t.boolean :accepted
      t.datetime :start_at
      t.text :note
      t.timestamps
    end
    add_index :booking_offers, [:artist_id, :requestor_id,]
    add_index :booking_offers, [:requestor_id, :artist_id]
  end
end
