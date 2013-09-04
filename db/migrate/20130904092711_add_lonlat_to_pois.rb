class AddLonlatToPois < ActiveRecord::Migration
  def change
    add_column :pois, :lonlat, :point, :geographic => true
  end
end
