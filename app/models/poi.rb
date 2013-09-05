class Poi < ActiveRecord::Base
  attr_writer :lon, :lat

  def city_country
    "#{city}, #{country}"
  end

  def name_id
    [name, id]
  end

  def lon
    @lon ||= lonlat.try(:x)
  end

  def lat
    @lat ||= lonlat.try(:y)
  end

  self.rgeo_factory_generator = RGeo::Geographic.spherical_factory(srid: 4326)

  def nearest(count=1)
    order = "lonlat::geometry <-> st_setsrid(st_makepoint(#{lon},#{lat}),4326)"
    Poi.order(order).offset(1).limit(count)
  end

  before_save do
    self[:lonlat] = "POINT(#{lon} #{lat})"
  end
end
