User.all.map(&:destroy)
user_attributes = {
  first_name: "Artist FN",
  last_name: "Artist LN",
  city: "Berlin", 
  mobile: "013456789" 
}

profile_attributes = {
  price: 123,
  genre_ids: Genre.all.map(&:id),
  tagline: "Here is my tagline.",
  about: "My father is a Jazz Drummer so i learned the drums",
  style: "When it comes to genres i'm a jack of all trades Techno, Minimal...",
}


10.times do |t|
  user = User.new
  user_attributes.each do |key, val|
    user.send("#{key}=", "#{val}#{t+1}")
  end
  profile = Profile.new
  profile_attributes.each do |key, val|
    profile.send("#{key}=", val)
  end  
  user.confirmed_at = Time.now
  user.password = user.password_confirmation = "12345678"
  user.email = "artist#{t+1}@example.com"
  user.skip_confirmation!
  user.save
  user.profiles << profile  
  print "."; STDOUT.flush
end
puts ""
