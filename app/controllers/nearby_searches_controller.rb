class NearbySearchesController < ApplicationController
  def show
    @poi = Poi.find(params[:poi_id] || 1)
    @count = params[:count] || 9
    @nearby_pois = @poi.nearest @count
  end
end
