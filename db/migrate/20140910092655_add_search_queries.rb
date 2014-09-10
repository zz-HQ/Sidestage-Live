class AddSearchQueries < ActiveRecord::Migration
  def self.up
    
    drop_table :city_launches
    
    create_table :search_queries do |t|
      t.string :location
      t.text :content
      t.integer :counter, default: 0
    end
    add_index :search_queries, :location
  end
  
  def self.down
    
    drop_table :search_queries
    
    create_table :city_launches do |t|
      t.string :email
      t.string :city
      t.timestamps
    end    
  end
  
end
