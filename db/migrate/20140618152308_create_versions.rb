class CreateVersions < ActiveRecord::Migration
  def change
    create_table :lead_versions do |t|
      t.string   :item_type, :null => false
      t.integer  :item_id,   :null => false
      t.string   :event,     :null => false
      t.string   :whodunnit
      t.text     :object
      t.datetime :created_at
    end
    add_index :versions, [:item_type, :item_id]
    
    add_column :deals, :state, :string
    add_column :deals, :state_transition_at, :datetime
    add_index :deals, :state
    
  end
end
