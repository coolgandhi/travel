class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|
      t.string :trip_id
      t.string :author_id
      t.string :location_id
      t.string :traveler_type_id
      t.string :trip_name
      t.string :trip_summary
      t.string :duration

      t.timestamps
    end
  end
end
