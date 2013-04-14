class RenameSelfTripActivityPhotoActivityIdColumn < ActiveRecord::Migration
  def up
    rename_column :self_trip_activity_photos, :activity_id, :trip_activity_id
  end

  def down
  end
end
