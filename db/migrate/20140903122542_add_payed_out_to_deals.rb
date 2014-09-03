class AddPayedOutToDeals < ActiveRecord::Migration
  def change
    add_column :deals, :payed_out, :boolean, default: false
  end
end
