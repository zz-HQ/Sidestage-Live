module ArtistsHelper
  
  def artist_price(artist)
    localized_price(artist.price.with_surcharge, artist.currency)    
  end
  
end
