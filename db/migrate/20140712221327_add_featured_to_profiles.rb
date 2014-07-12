class AddFeaturedToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :featured, :boolean, default: false    
    add_index :profiles, :featured
  end
end
