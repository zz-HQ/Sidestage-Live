Currency.connection.execute("TRUNCATE currencies")
Currency.create(name: "USD", symbol: "$")
Currency.create(name: "EUR", symbol: "€")

Deal.connection.execute("TRUNCATE conversations")
Deal.connection.execute("TRUNCATE messages")
Deal.connection.execute("TRUNCATE deals")

User.all.map(&:destroy)
User.connection.execute("TRUNCATE users")
User.connection.execute("TRUNCATE profiles")

Genre.connection.execute("TRUNCATE genres")
["Classical", "Party DJ", "Alternative", "Acappella","Acid Jazz","Afro-Brazilian","Ambient","Americana","Avant-Garde","Ballroom Dance","Bar Band",
  "Baroque","Bluegrass","Blues","Brass Band","Cabaret","Celtic","Chamber Music","Chanukah","Children's",
  "Classical Guitar","Club/Dance","Conceptual Art","Country","Disco","Early Music","Eastern Europe",
  "Easy Listening","Electro","Electro-Techno","Electronic","Electronica","Emo","Ethnic","Experimental","Folk","Funk",
  "Gangsta Rap","German Schlager","German Volksmusik","Gospel","Grunge","Heavy Metal","Hip-Hop","House","Indie Rock",
  "Jam Bands","Jazz","Jewish Music","Latin","Lounge","Military","Minimal Techno","Motown","New Age","Noise","Opera",
  "Pipe Bands","Punk","R&B","Ragtime","Rap","Reggae","Rock","Rock & Roll","Romantic","Salsa","Samba",
  "Singer/Songwriter","Soft Rock","Solo Instrumental","Steel Band","Tech-House","Techno","Traditional",
  "Traditional Native American","Trance","Turkish Music","Urban","Waltz","Wedding Music"].each do |g|
  Genre.create(name: g)
end


artist_attributes = [
  {
    first_name: "Taylor",
    last_name: "Swift",
    city: ["Berlin", "London"].sample, 
    mobile: "013456789",
    avatar: File.open("#{Rails.root.to_s}/public/seed/taylor-swift.jpg"),
    currency: "EUR"
  },
  {
    first_name: "Justin",
    last_name: "Timberlake",
    city: ["Berlin", "London"].sample, 
    mobile: "013456789",
    avatar: File.open("#{Rails.root.to_s}/public/seed/justin-timberlake.jpg"),
    currency: "EUR"
  },
  {
    first_name: "Bon",
    last_name: "Jovi",
    city: ["Berlin", "London"].sample, 
    mobile: "013456789",
    avatar: File.open("#{Rails.root.to_s}/public/seed/bon-jovi.jpg"),
    currency: "EUR"    
  },
  {
    first_name: "The",
    last_name: "Rolling Stones",
    city: ["Berlin", "London"].sample, 
    mobile: "013456789",
    avatar: File.open("#{Rails.root.to_s}/public/seed/the-rolling-stones.jpg") ,
    currency: "EUR"    
  },
  {
    first_name: "Beyoncé",
    last_name: "Knowles",
    city: ["Berlin", "London"].sample, 
    mobile: "013456789",
    avatar: File.open("#{Rails.root.to_s}/public/seed/beyonce.jpg"),
    currency: "EUR"    
  },
  {
    first_name: "P!nk",
    last_name: "Floyd",
    city: ["Berlin", "London"].sample, 
    mobile: "013456789",
    avatar: File.open("#{Rails.root.to_s}/public/seed/pink.jpg"),
    currency: "EUR"
  }
]
  

profile_attributes = {
  published: true,
  location: ["Berlin", "London"].sample, 
  price: 22,
  currency: "EUR",
  name: "Pro",
  title: "Here is my tagline.",
  about: "My father is a Jazz Drummer so i learned the drums. Lorem ipsum dolor sit amet, consectetur adipisicing elit. Velit, et, assumenda non exercitationem vitae nulla minima consectetur ex! Neque, itaque voluptate consectetur dignissimos non voluptatibus nisi cumque quis nulla ipsa!",
}


6.times do |t|

  user = User.new
  user.first_name = artist_attributes[t][:first_name]
  user.last_name = artist_attributes[t][:last_name]
  user.city = artist_attributes[t][:city]
  user.mobile = artist_attributes[t][:mobile]
  user.avatar = artist_attributes[t][:avatar]

  profile = Profile.new
  profile_attributes.each do |key, val|
   profile.send("#{key}=", val)
  end
  profile.name = "#{user.first_name} #{user.last_name}"
  profile.price = rand(500)
  profile.genre_ids = Genre.all.map(&:id).sample
  user.confirmed_at = Time.now
  user.password = user.password_confirmation = "12345678"
  user.email = "artist#{t+1}@example.com"
  user.skip_confirmation!
  user.save
  user.profiles << profile  
  print "."; STDOUT.flush
end
puts ""

%x[rake currency:update_rates]