class FixColumnName < ActiveRecord::Migration
  #def up
  #end

  #def down
  #end
  def change
    rename_column :food_activity, :restaurant_details_id, :restaurant_detail_id
    rename_column :location_activity, :location_details_id, :location_detail_id
  end
end
