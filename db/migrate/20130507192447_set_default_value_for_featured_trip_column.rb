class SetDefaultValueForFeaturedTripColumn < ActiveRecord::Migration
  def up
    change_column :trips, :featured_trip_flag, :boolean, :default => false 
  end

  def down
  end
end
