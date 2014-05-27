class CreateBookingRequests < ActiveRecord::Migration
  def change
    create_table :booking_requests do |t|
      t.integer :requestor_id
      t.integer :artist_id
      t.integer :price
      t.boolean :accepted
      t.datetime :start_at
      t.text :note
      t.timestamps
    end
    add_index :booking_requests, [:artist_id, :requestor_id,]
    add_index :booking_requests, [:requestor_id, :artist_id]    

  end
end
