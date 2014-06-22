class AddPositionToPicture < ActiveRecord::Migration
  def change
    add_column :pictures, :position, :integer
    add_index :pictures, :position
  end
end
