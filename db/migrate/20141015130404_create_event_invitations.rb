class CreateEventInvitations < ActiveRecord::Migration
  def change
    create_table :event_invitations do |t|
      t.integer :event_id
      t.integer :inviter_id
      t.boolean :signed_up
      t.boolean :visited
      t.boolean :accepted
      t.boolean :rejected
      t.string :email
      t.string :token
      t.timestamps
    end
    
    add_column :events, :event_invitations_count, :integer
    add_index :event_invitations, :event_id
    add_index :event_invitations, :token
    
  end
end
