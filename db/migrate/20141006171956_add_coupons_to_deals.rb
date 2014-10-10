class AddCouponsToDeals < ActiveRecord::Migration
  def change
    # add_column :users, :birthday, :string
    # add_column :coupons, :deals_count, :integer
    # add_index :coupons, :code
    # 
    # add_column :deals, :coupon_id, :integer
    # add_column :deals, :coupon_code, :string
    # add_column :deals, :coupon_price, :integer
    # add_column :deals, :customer_price, :integer
    # rename_column :deals, :price, :artist_price
    # 
    # add_index :deals, :coupon_id
    Deal.update_all "customer_price = (artist_price + (artist_price * 0.20))"
  end
end
