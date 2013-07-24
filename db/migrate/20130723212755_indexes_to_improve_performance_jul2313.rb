class IndexesToImprovePerformanceJul2313 < ActiveRecord::Migration
  def up
    change_column(:trip_activities, :trip_id, :integer)
    change_column(:trip_stats, :trip_id, :integer)
    change_column(:trip_stats, :author_info_id, :integer)
    change_column(:trips, :author_id, :integer)
    add_index :trips, :author_id, :name=>'trips_author_id_index'
    add_index :trip_stats, :trip_id, :name=>'trip_stats_trip_id_index', :unique => true
    add_index :trip_stats, :author_info_id, :name=>'trip_stats_author_info_id_index'
    add_index :self_trip_activity_photos, :trip_activity_id, :name=>'trip_activity_photo_index'
    
  end

  def down
    remove_index :trips, :name=>'trips_author_id_index'
    remove_index :trip_stats, :name=>'trip_stats_index'
    remove_index :trip_stats, :name=>'trip_stats_author_info_id_index'    
    remove_index :self_trip_activity_photos, :name=>'trip_activity_photo_index'
    change_column(:trip_activities, :trip_id, :string)
    change_column(:trip_stats, :trip_id, :string)
    change_column(:trip_stats, :author_info_id, :string)
    change_column(:trips, :author_id, :string)
  end
end
