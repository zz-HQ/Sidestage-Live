class AddArchive < ActiveRecord::Migration
  def change
    add_column :users, :phone_nr_verified_at, :datetime
    add_column :users, :verified, :boolean, default: false
    User.connection.execute("UPDATE users SET verified = 1")
    
    add_column :messages, :customer_archived, :boolean, default: false
    add_column :messages, :artist_archived, :boolean, default: false
  end
end
