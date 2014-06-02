class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.integer :user_id
      t.integer :price
      t.string :tagline
      t.text :description
      t.text :about
      t.string :youtube
      t.string :soundcloud
      t.text :style
      t.timestamps
    end
    add_index :profiles, :user_id    
  end
end
