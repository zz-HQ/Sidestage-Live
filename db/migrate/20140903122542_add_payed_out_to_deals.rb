class AddPayedOutToDeals < ActiveRecord::Migration
  def change
    add_column :deals, :paid_out, :boolean, default: false
  end
end
