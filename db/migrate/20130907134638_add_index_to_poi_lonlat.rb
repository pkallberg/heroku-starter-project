class AddIndexToPoiLonlat < ActiveRecord::Migration
  def change
    add_index :pois, :lonlat, using: 'GIST'
  end
end
