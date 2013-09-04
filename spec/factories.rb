FactoryGirl.define do
  factory :poi do
    name 'Big Ben'
    city 'London'
    country 'England'
    lon -0.1245748
    lat 51.5007046
    
    factory :tower_bridge do
      name 'Tower Bridge'
      city 'London'
      country 'England'
      lon -0.07544039999999999
      lat 51.50548089999999
    end

    factory :eiffel_tower do
      name 'Eiffel Tower'
      city 'Paris'
      country 'France'
      lon 2.2946
      lat 48.858
    end

    factory :pantheon do
      name 'Pantheon'
      city 'Rome'
      country 'Italy'
      lon 12.4768665
      lat 41.89862919999999
    end
  end
end
