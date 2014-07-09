Currency.connection.execute("TRUNCATE currencies")
Currency.connection.execute("TRUNCATE currency_rates")
Currency.create(name: "USD", symbol: "$")
Currency.create(name: "EUR", symbol: "€")
Currency.create(name: "GBP", symbol: "£")

Deal.connection.execute("TRUNCATE deal_versions")
Deal.connection.execute("TRUNCATE conversations")
Deal.connection.execute("TRUNCATE messages")
Deal.connection.execute("TRUNCATE deals")

User.all.map(&:destroy)
User.connection.execute("TRUNCATE users")
User.connection.execute("TRUNCATE profiles")
User.connection.execute("TRUNCATE pictures")
User.connection.execute("TRUNCATE reviews")

Genre.connection.execute("TRUNCATE genres_profiles")
Genre.connection.execute("TRUNCATE genres")
["Classical",
	"Party DJ",
	"Indie",
	"Acappella",
"Baroque",
"Bluegrass",
"Blues",
"Country",
"Electronic",
"Ethnic",
"Experimental",
"Folk",
"Funk",
"Gospel",
"Hip hop",
"Jazz",
"Latin",
"Minimal Techno",
"Opera",
"Other",
"Ragtime",
"Reggae",
"Rock",
"Singer/Songwriter",
"Techno",
"Traditional",
"Wedding Music"
].each do |g|
  Genre.create(name: g)
end


#artist_attributes = [
#  {
#    first_name: "Taylor",
#    last_name: "Swift",
#    city: ["Berlin", "London"].sample, 
#    mobile: "013456789",
#    avatar: File.open("#{Rails.root.to_s}/public/seed/taylor-swift.jpg"),
#    currency: "EUR"
#  },
#  {
#    first_name: "Justin",
#    last_name: "Timberlake",
#    city: ["Berlin", "London"].sample, 
#    mobile: "013456789",
#    avatar: File.open("#{Rails.root.to_s}/public/seed/justin-timberlake.jpg"),
#    currency: "EUR"
#  },
#  {
#    first_name: "Bon",
#    last_name: "Jovi",
#    city: ["Berlin", "London"].sample, 
#    mobile: "013456789",
#    avatar: File.open("#{Rails.root.to_s}/public/seed/bon-jovi.jpg"),
#    currency: "EUR"    
#  },
#  {
#    first_name: "The",
#    last_name: "Rolling Stones",
#    city: ["Berlin", "London"].sample, 
#    mobile: "013456789",
#    avatar: File.open("#{Rails.root.to_s}/public/seed/the-rolling-stones.jpg") ,
#    currency: "EUR"    
#  },
#  {
#    first_name: "Beyoncé",
#    last_name: "Knowles",
#    city: ["Berlin", "London"].sample, 
#    mobile: "013456789",
#    avatar: File.open("#{Rails.root.to_s}/public/seed/beyonce.jpg"),
#    currency: "EUR"    
#  },
#  {
#    first_name: "P!nk",
#    last_name: "Floyd",
#    city: ["Berlin", "London"].sample, 
#    mobile: "013456789",
#    avatar: File.open("#{Rails.root.to_s}/public/seed/pink.jpg"),
#    currency: "EUR"
#  }
#]
#  
#
#profile_attributes = {
#  published: true,
#  location: ["Berlin", "London"].sample, 
#  price: 22,
#  currency: "EUR",
#  name: "Pro",
#  title: "Here is my tagline.",
#  about: "My father is a Jazz Drummer so i learned the drums. Lorem ipsum dolor sit amet, consectetur adipisicing elit. Velit, et, assumenda non exercitationem vitae nulla minima consectetur ex! Neque, itaque voluptate consectetur dignissimos non #voluptatibus nisi cumque quis nulla ipsa!",
#}
#
#
#6.times do |t|
#
#  user = User.new
#  user.first_name = artist_attributes[t][:first_name]
#  user.last_name = artist_attributes[t][:last_name]
#  user.city = artist_attributes[t][:city]
#  user.mobile = artist_attributes[t][:mobile]
#  user.avatar = artist_attributes[t][:avatar]
#
#  profile = Profile.new
#  profile_attributes.each do |key, val|
#   profile.send("#{key}=", val)
#  end
#  profile.name = "#{user.first_name} #{user.last_name}"
#  profile.price = rand(500)
#  profile.genre_ids = Genre.all.map(&:id).sample
#  user.confirmed_at = Time.now
#  user.password = user.password_confirmation = "12345678"
#  user.email = "artist#{t+1}@example.com"
#  user.skip_confirmation!
#  user.save
#  user.profiles << profile  
#  print "."; STDOUT.flush
#end
#puts ""

%x[rake currency:update_rates]