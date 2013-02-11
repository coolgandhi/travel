class AddIndexesToLocationRestaurantTripActivitiesLocations < ActiveRecord::Migration
  def up
    add_index :restaurant_details, :restaurant_detail_id, :name=>'restaurant_detail_index', :unique => true
    add_index :location_details, :location_detail_id, :name=>'location_detail_index', :unique => true
    add_index :trip_activities, :trip_id, :name=>'trip_index'
    add_index :locations, :location_id, :name=>'location_index', :unique => true
    add_index :locations, :city, :name=>'city_index'
  end
  
  def down
    remove_index :restaurant_details, :restaurant_detail_id
    remove_index :location_details, :location_detail_id
    remove_index :trip_activities, :trip_id
    remove_index :locations, :location_id
    remove_index :locations, :city
  end
end
