class CreateActivityDurationTypes < ActiveRecord::Migration
  def change
    create_table :activity_duration_types do |t|
      t.string :activity_duration_type_id
      t.string :activity_duration_name

      t.timestamps
    end
  end
end
