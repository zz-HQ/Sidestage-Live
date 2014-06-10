class CreateMessages < ActiveRecord::Migration
  def up
    create_table :messages do |t|
      t.integer :sender_id, null: false
      t.integer :receiver_id, null: false
      t.string :subject
      t.text :body
      t.datetime :read_at
      t.integer :conversation_id, null: false
      t.timestamps
    end
    add_index :messages, :conversation_id
    add_index :messages, :sender_id
    add_index :messages, :receiver_id
    
    add_column :users, :unread_message_counter, :integer
          
  end
  
  def down
    remove_column :users, :unread_message_counter
    drop_table :messages
  end
  
end
