class AddActToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :solo, :boolean, default: true
    add_column :profiles, :location, :string
    add_column :users, :role, :string
  end
end
