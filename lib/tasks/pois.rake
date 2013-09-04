require 'csv'
require 'json'
require 'net/http'

namespace :pois do
  desc "Geocode POIs in /db/pois.csv. Output to /db/pois_geocoded.csv"
  task :geocode => :environment do
    pois = Rails.root.join('db/pois.csv')
    geocoded_pois = Rails.root.join('db/geocoded_pois.csv')
    CSV.open(geocoded_pois, 'wb') do |geocoded_poi|
      geocoded_poi << %w(name city country lat lon)
      CSV.foreach(pois, headers: true) do |poi|
        puts "#{poi['name']}, #{poi['city']}"
        url = URI.escape "http://maps.googleapis.com/maps/api/geocode/json"\
        "?address=#{poi['name']},#{poi['city']},#{poi['country']}&sensor=false"
        resp = Net::HTTP.get_response(URI.parse(url))
        data = resp.body
        json = JSON.parse data
        location = json['results'][0]['geometry']['location']
        lat = location['lat']
        lon = location['lng']
        geocoded_poi << [ poi['name'], poi['city'], poi['country'], lat, lon]
      end
    end
  end
end
