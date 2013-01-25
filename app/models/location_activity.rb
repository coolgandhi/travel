class LocationActivity < ActiveRecord::Base
  belongs_to :location_detail, :primary_key => :location_detail_id
  has_one    :trip, :through => :trip_activities
  has_one :trip_activity, :as =>:activity
  attr_accessible :activity_id, :description, :duration, :location_detail_id, :quick_tip
end
