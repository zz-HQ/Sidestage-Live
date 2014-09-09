class RenameSolo < ActiveRecord::Migration

  def self.up
    rename_column :profiles, :solo, :artist_type
    change_column :profiles, :artist_type, :integer
    change_column_default :profiles, :artist_type, 0
  end
  
  def self.down
    rename_column :profiles, :artist_type, :solo
  end
  
end
