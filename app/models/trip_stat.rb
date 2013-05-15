class TripStat < ActiveRecord::Base
  belongs_to :author_info
  belongs_to :trip
  attr_accessible :trip_id, :emailed, :fb_shared, :likes, :numbers_rated, :pinned, :total_rating, :tweets, :useful, :author_info_id, :trip_views, :trip_activities, :trip_durations
end
