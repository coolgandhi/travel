class CreateTripActivities < ActiveRecord::Migration
  def change
    create_table :trip_activities do |t|
      t.string :trip_id
      t.string :activity_id
      t.string :activity_day
      t.integer :activity_sequence_number
      t.string :activity_type
      t.string :activity_time_type

      t.timestamps
    end
  end
end
