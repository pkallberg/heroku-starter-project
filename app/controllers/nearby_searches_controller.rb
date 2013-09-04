class NearbySearchesController < ApplicationController
  def show
    @poi = Poi.find params[:id]
    @nearby_pois = @poi.nearest 10
  end
end
