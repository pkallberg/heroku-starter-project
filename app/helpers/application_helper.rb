module ApplicationHelper
  def poi_options
    pois_by_city = Poi.all.group_by(&:city_country)
    pois_by_city.each{ |ary| ary.last.map! &:name_id }
  end

  def count_options
    [2,5,10,20,30,50,100].map{ |x| [x, x-1] }
  end
end
