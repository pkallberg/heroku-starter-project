class NearbySearchesController < ApplicationController
  def show
    @poi = Poi.find(params[:poi_id] || Poi.where(name: 'Plaza Mayor').first.id)
    @count = params[:count] || 1
    @nearby_pois = @poi.nearest @count
  end
end
