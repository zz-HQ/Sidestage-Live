class AddPricingToProfiles < ActiveRecord::Migration
  def change
    add_column :users, :stripe_token, :string
    add_column :users, :stripe_log, :text
    
    add_column :profiles, :currency, :string
    add_column :profiles, :additionals, :text
    add_column :profiles, :avatar, :string
    
    remove_column :profiles, :youtube, :string
    remove_column :profiles, :soundcloud, :string
  end
end
