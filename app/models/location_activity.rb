class LocationActivity < ActiveRecord::Base
  belongs_to :trip_activity
  attr_accessible :activity_id, :description, :duration, :location_detail_id, :quick_tip
end
