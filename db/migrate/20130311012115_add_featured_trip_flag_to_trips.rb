class AddFeaturedTripFlagToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :featured_trip_flag, :boolean
  end
end
