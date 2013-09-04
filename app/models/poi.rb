class Poi < ActiveRecord::Base
  attr_writer :lon, :lat

  def lon
    @lon ||= lonlat.try(:x)
  end

  def lat
    @lat ||= lonlat.try(:y)
  end

  before_save do
    self[:lonlat] = "POINT(#{lon} #{lat})"
  end
end
