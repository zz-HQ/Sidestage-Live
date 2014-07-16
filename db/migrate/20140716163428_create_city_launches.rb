class CreateCityLaunches < ActiveRecord::Migration
  def change
    create_table :city_launches do |t|
      t.string :email
      t.string :city
      t.timestamps
    end
  end
end
