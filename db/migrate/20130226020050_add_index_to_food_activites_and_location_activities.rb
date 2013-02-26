class AddIndexToFoodActivitesAndLocationActivities < ActiveRecord::Migration
  def up
     add_index :food_activities, :restaurant_detail_id, :name=>'restaurant_detail_index'
     add_index :location_activities, :location_detail_id, :name=>'location_detail_index'
   end
   def down
     remove_index :food_activities, :name=>'restaurant_detail_index'
     remove_index :location_activities, :name=>'location_detail_index' 
   end
end
