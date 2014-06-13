User.all.map(&:destroy)
Genre.all.map(&:destroy)


["Electro", "Jazz", "Classic", "Pop", "Rock", "Techno"].each do |g|
  Genre.create(name: g)
end


artist_attributes = [
  {
    first_name: "Taylor",
    last_name: "Swift",
    city: "Berlin", 
    mobile: "013456789",
    avatar: File.open("#{Rails.root.to_s}/public/seed/taylor-swift.jpg"),
    currency: "EUR"
  },
  {
    first_name: "Justin",
    last_name: "Timberlake",
    city: "Berlin", 
    mobile: "013456789",
    avatar: File.open("#{Rails.root.to_s}/public/seed/justin-timberlake.jpg"),
    currency: "EUR"
  },
  {
    first_name: "Bon",
    last_name: "Jovi",
    city: "London", 
    mobile: "013456789",
    avatar: File.open("#{Rails.root.to_s}/public/seed/bon-jovi.jpg"),
    currency: "EUR"    
  },
  {
    first_name: "The",
    last_name: "Rolling Stones",
    city: "Berlin", 
    mobile: "013456789",
    avatar: File.open("#{Rails.root.to_s}/public/seed/the-rolling-stones.jpg") ,
    currency: "EUR"    
  },
  {
    first_name: "Beyoncé",
    last_name: "",
    city: "Berlin", 
    mobile: "013456789",
    avatar: File.open("#{Rails.root.to_s}/public/seed/beyonce.jpg"),
    currency: "EUR"    
  },
  {
    first_name: "P!nk",
    last_name: "",
    city: "Berlin", 
    mobile: "013456789",
    avatar: File.open("#{Rails.root.to_s}/public/seed/pink.jpg"),
    currency: "EUR"
  }
]
  

profile_attributes = {
  published: true,
  location: "Berlin",
  tagline: "Here is my tagline.",
  about: "My father is a Jazz Drummer so i learned the drums. Lorem ipsum dolor sit amet, consectetur adipisicing elit. Velit, et, assumenda non exercitationem vitae nulla minima consectetur ex! Neque, itaque voluptate consectetur dignissimos non voluptatibus nisi cumque quis nulla ipsa!",
  style: "When it comes to genres i'm a jack of all trades Techno, Minimal...",
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