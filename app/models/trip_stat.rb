class TripStat < ActiveRecord::Base
  belongs_to :trip
  attr_accessible : trip_id, :emailed, :fb_shared, :likes, :numbers_rated, :pinned, :total_rating, :tweets
end
