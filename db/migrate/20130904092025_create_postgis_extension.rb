class CreatePostgisExtension < ActiveRecord::Migration
  def change
    enable_extension :postgis
  end
end
