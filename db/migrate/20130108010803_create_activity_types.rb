class CreateActivityTypes < ActiveRecord::Migration
  def change
    create_table :activity_types do |t|
      t.string :activity_type_id
      t.string :activity_name

      t.timestamps
    end
  end
end
