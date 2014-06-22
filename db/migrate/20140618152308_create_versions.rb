class CreateVersions < ActiveRecord::Migration
  def change
    create_table :deal_versions do |t|
      t.string   :item_type, :null => false
      t.integer  :item_id,   :null => false
      t.string   :event,     :null => false
      t.string   :whodunnit
      t.text     :object
      t.datetime :created_at
    end
    add_index :deal_versions, [:item_type, :item_id]
    
    add_column :messages, :system_message, :boolean

    rename_column :deals, :note, :body

    remove_column :deals, :message_id, :integer
    remove_column :deals, :artist_accepted_at, :datetime
    remove_column :deals, :customer_accepted_at, :datetime
    remove_column :deals, :offer, :boolean
    add_column :deals, :state, :string
    add_column :deals, :state_transition_at, :datetime
    add_index :deals, :state
    
  end
end
