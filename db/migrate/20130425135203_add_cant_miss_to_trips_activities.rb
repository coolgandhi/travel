class AddCantMissToTripsActivities < ActiveRecord::Migration
  def change
    add_column :trip_activities, :cant_miss, :boolean
  end
end
