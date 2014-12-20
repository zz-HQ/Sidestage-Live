class AddAdditionalToUsers < ActiveRecord::Migration
  def change
    add_column :users, :additionals, :text
  end
end
