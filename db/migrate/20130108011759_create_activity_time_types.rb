class CreateActivityTimeTypes < ActiveRecord::Migration
  def change
    create_table :activity_time_types do |t|
      t.string :activity_time_type_id
      t.string :activity_period

      t.timestamps
    end
  end
end
