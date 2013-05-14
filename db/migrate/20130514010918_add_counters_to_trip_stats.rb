class AddCountersToTripStats < ActiveRecord::Migration
  def change
    add_column :trip_stats, :author_info_id, :string
    add_column :trip_stats, :trip_views, :integer, :default => 0
    add_column :trip_stats, :trip_activities, :integer, :default => 0
    add_column :author_infos, :badge_level, :string, :default => ""
  end
end
