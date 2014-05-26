class AddBasicUserFields < ActiveRecord::Migration
  def up
    add_column :users, :airmusic_name, :string
    add_column :users, :avatar, :string
    add_column :users, :city, :string
    add_column :users, :unread_messages_counter, :integer
    add_column :users, :received_messages_counter, :integer
        
    remove_column :profiles, :city
    add_column :profiles, :soundcloud, :string
    add_column :profiles, :style, :text
    rename_column :profiles, :name, :tagline
  end
  
  def down
    rename_column :profiles, :tagline, :name
    remove_column :profiles, :style
    remove_column :profiles, :soundcloud    
    add_column :profiles, :city, :string
    
    remove_column :users, :received_messages_counter
    remove_column :users, :unread_messages_counter
    remove_column :users, :city
    remove_column :users, :avatar
    remove_column :users, :airmusic_name
                
  end

end
