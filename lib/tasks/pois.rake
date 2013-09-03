require 'csv'

namespace :pois do
  desc "Geocode POIs in /db/pois.csv. Output to /db/pois_geocoded.csv"
  task :geocode => :environment do
    pois = Rails.root.join('db/pois.csv')
    CSV.foreach(pois, headers: true) do |row|
      puts row['name']
    end
  end
end
