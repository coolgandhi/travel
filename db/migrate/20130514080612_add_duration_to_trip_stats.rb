class AddDurationToTripStats < ActiveRecord::Migration
  def change
    add_column :trip_stats, :trip_durations, :integer, :default => 0    
  end
end
