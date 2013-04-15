class AddRatingsTwitterHandleToLocationRestaurantDetails < ActiveRecord::Migration
  def change
    add_column :location_details, :rating, :string
    add_column :location_details, :twitter, :string
    add_column :location_details, :source, :string, :default => "foursquare"
    add_column :restaurant_details, :rating, :string
    add_column :restaurant_details, :twitter, :string
    add_column :restaurant_details, :source, :string, :default => "foursquare"
  end
end
