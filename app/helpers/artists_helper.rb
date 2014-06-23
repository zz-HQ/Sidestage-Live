module ArtistsHelper
  
  def artist_price(artist)
    localized_price(artist.price_with_surcharge, artist.currency)    
  end
  
end
