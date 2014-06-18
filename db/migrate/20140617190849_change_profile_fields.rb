class ChangeProfileFields < ActiveRecord::Migration
  def up
    rename_column :profiles, :tagline, :name
    rename_column :profiles, :description, :title
    remove_column :profiles, :style

    Profile.connection.execute("UPDATE profiles SET price = (price / 100)")
    
    genres = ["Classical", "Party DJ", "Alternative", "Acappella","Acid Jazz","Afro-Brazilian","Ambient","Americana","Avant-Garde","Ballroom Dance","Bar Band",
      "Baroque","Bluegrass","Blues","Brass Band","Cabaret","Celtic","Chamber Music","Chanukah","Children's",
      "Classical Guitar","Club/Dance","Conceptual Art","Country","Disco","Early Music","Eastern Europe",
      "Easy Listening","Electro","Electro-Techno","Electronic","Electronica","Emo","Ethnic","Experimental","Folk","Funk",
      "Gangsta Rap","German Schlager","German Volksmusik","Gospel","Grunge","Heavy Metal","Hip-Hop","House","Indie Rock",
      "Jam Bands","Jazz","Jewish Music","Latin","Lounge","Military","Minimal Techno","Motown","New Age","Noise","Opera",
      "Pipe Bands","Punk","R&B","Ragtime","Rap","Reggae","Rock","Rock & Roll","Romantic","Salsa","Samba",
      "Singer/Songwriter","Soft Rock","Solo Instrumental","Steel Band","Tech-House","Techno","Traditional",
      "Traditional Native American","Trance","Turkish Music","Urban","Waltz","Wedding Music"]
    Genre.connection.execute("TRUNCATE genres")
    genres.each do |g|
      Genre.create name: g
    end
    
  end
  
  def down
    add_column :profiles, :style, :text
    rename_column :profiles, :title, :description
    rename_column :profiles, :name, :tagline
  end
  
end
