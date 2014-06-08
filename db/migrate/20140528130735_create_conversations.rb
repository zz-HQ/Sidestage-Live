class CreateConversations < ActiveRecord::Migration
  def change
    create_table :conversations do |t|
      t.integer :sender_id, null: false
      t.integer :receiver_id, null: false
      t.string :subject
      t.text :body
      t.datetime :last_message_at
      t.timestamps      
    end
    add_index :conversations, :sender_id
    add_index :conversations, :receiver_id

  end
end
