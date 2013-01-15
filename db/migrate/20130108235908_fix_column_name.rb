class FixColumnName < ActiveRecord::Migration
  #def up
  #end

  #def down
  #end
  def change
    rename_column :food_activities, :restaurant_details_id, :restaurant_detail_id
    rename_column :location_activities, :location_details_id, :location_detail_id
  end
end
