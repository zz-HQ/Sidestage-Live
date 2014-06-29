class AddBankDataToProfile < ActiveRecord::Migration
  def change
    remove_column :users, :social_media, :text
    remove_column :users, :airmusic_name, :string
    rename_column :users, :stripe_token, :stripe_card_id
    
    add_column :profiles, :payout, :text

    User.connection.execute("UPDATE users SET stripe_card_id = NULL")
  end
end
