require 'csv'

Poi.delete_all
geocoded_pois = Rails.root.join('db/geocoded_pois.csv')
CSV.foreach(geocoded_pois, headers: true) do |poi|
  Poi.create(
    name: poi['name'],
    city: poi['city'],
    country: poi['country'],
    lat: poi['lat'],
    lon: poi['lon']
  )
end