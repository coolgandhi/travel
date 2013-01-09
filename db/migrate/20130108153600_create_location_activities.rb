class CreateLocationActivities < ActiveRecord::Migration
  def change
    create_table :location_activities do |t|
      t.string : activity_id
      t.string :location_details_id
      t.string :description
      t.string :quick_tip
      t.string :duration

      t.timestamps
    end
  end
end
