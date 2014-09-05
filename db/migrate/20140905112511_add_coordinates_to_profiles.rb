class AddCoordinatesToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :latitude, :decimal, precision: 14, scale: 11
    add_column :profiles, :longitude, :decimal, precision: 14, scale: 11
    add_column :profiles, :country_long, :string
    add_column :profiles, :country_short, :string
    
    add_index :profiles, :latitude
    add_index :profiles, :longitude
    
    coordinates = {
      "New York City" => { country_long: "USA", country_short: "US", latitude: "40.7127", longitude: "74.0059" },
      "Berlin" => { country_long: "Germany", country_short: "DE", latitude: "52.5167", longitude: "13.3833" },
      "London" => { country_long: "United Kingdom", country_short: "UK", latitude: "51.5072", longitude: "0.1275" },
    }
    Profile.all.each do |profile|
      profile.latitude = coordinates[profile.location][:latitude]
      profile.longitude = coordinates[profile.location][:longitude]
      profile.country_long = coordinates[profile.location][:country_long]
      profile.country_short = coordinates[profile.location][:country_short]
      profile.save validate: false
    end
    
  end
  
end
