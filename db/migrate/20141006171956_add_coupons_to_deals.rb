class AddCouponsToDeals < ActiveRecord::Migration
  def change
    add_column :users, :dob, :datetime
    add_column :coupons, :deals_count, :integer
    add_index :coupons, :code
    
    add_column :deals, :coupon_id, :integer
    add_column :deals, :coupon_code, :string
    add_column :deals, :coupon_amount, :integer
    add_column :deals, :coupon_currency, :string
    add_index :deals, :coupon_id
    
  end
end
