module ArtistsHelper
  
  def artist_price(artist)
    localized_price(artist.price.with_surcharge, artist.currency)    
  end
  
  def artist_filter_order
    options_from_collection_for_select(
      [
        [t(:"helpers.select.filter.order.serendipity"), ""],
        [t(:"helpers.select.filter.order.price_asc"), :price_asc],
        [t(:"helpers.select.filter.order.price_desc"), :price_desc],
        [t(:"helpers.select.filter.order.alphabetical"), :alphabetical]
      ],
      :last, :first,  params[:filter_order])
  end
  
end
