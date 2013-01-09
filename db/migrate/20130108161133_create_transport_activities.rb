class CreateTransportActivities < ActiveRecord::Migration
  def change
    create_table :transport_activities do |t|
      t.string :activity_id
      t.string :transport_quick_tips
      t.string :transport_type_id
      t.string :duration
      t.string :source
      t.string :destination

      t.timestamps
    end
  end
end
