class AddGeoNameIdToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :geo_name_id, :string
  end
end
