class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.integer :user_id
      t.integer :price
      t.string :name
      t.text :description
      t.text :about
      t.string :youtube
      t.string :city
      t.timestamps
    end
  end
end
