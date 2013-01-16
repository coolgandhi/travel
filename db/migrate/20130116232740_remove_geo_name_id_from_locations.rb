class RemoveGeoNameIdFromLocations < ActiveRecord::Migration
  def up
    remove_column :locations, :geo_name_id
  end

  def down
    add_column :locations, :geo_name_id, :string
  end
end
