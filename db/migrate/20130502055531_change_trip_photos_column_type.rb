class ChangeTripPhotosColumnType < ActiveRecord::Migration
  def up
    change_column :self_trip_activity_photos, :trip_activity_id, :integer
  end

  def down
  end
end
