class AddIndexToTripActivities < ActiveRecord::Migration
  def change
    add_index :trip_activities, [:trip_id, :activity_day, :activity_sequence_number], :name=>'trip_activity_order_index' 
  end
end
