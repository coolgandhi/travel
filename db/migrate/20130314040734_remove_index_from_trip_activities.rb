class RemoveIndexFromTripActivities < ActiveRecord::Migration
  def up
    remove_index :trip_activities, :name=>'trip_activity_order_index' 
  end

  def down
    add_index :trip_activities, [:trip_id, :activity_day, :activity_sequence_number], :unique => true, :name=>'trip_activity_order_index' 
  end
end
