class AddFullNameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :full_name, :string
    User.connection.execute("UPDATE users set full_name = CONCAT(first_name, ' ', last_name)")
  end
end
