class CreateEventInvitations < ActiveRecord::Migration
  def change
    create_table :event_invitations do |t|
      t.integer :event_id
      t.integer :inviter_id
      t.boolean :invited
      t.boolean :visited
      t.boolean :accepted
      t.boolean :rejected
      t.integer :attendee_id
      t.string :email
      t.string :token
      t.integer :coupon_id
      t.string :coupon_price
      t.string :coupon_currency
      t.timestamps
    end
    
    add_column :events, :event_invitations_count, :integer
    add_column :events, :event_at, :datetime
    
    add_index :event_invitations, :event_id
    add_index :event_invitations, :token
    add_index :event_invitations, :attendee_id
  end
end
