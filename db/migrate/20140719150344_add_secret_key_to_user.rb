class AddSecretKeyToUser < ActiveRecord::Migration
  def change
    add_column :users, :otp_secret_key, :string
    add_column :users, :mobile_nr_country_code, :string
    rename_column :users, :mobile, :mobile_nr
    rename_column :users, :phone_nr_verified_at, :mobile_nr_confirmed_at
    rename_column :users, :stripe_log, :error_log
    
    User.all.each do |user|
        key = ROTP::Base32.random_base32
        user.update_attributes(:otp_secret_key => key)
        user.save
    end    
    
  end
end
