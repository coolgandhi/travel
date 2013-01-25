class ChangeStringFormatInTripActivities < ActiveRecord::Migration
  def up
    change_column(:trip_activities, :activity_id, :integer)
  end

  def down
    change_column(:trip_activities, :activity_id, :string)
  end
end
