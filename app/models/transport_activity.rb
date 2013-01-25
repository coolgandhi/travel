class TransportActivity < ActiveRecord::Base
  has_one    :trip, :through => :trip_activities
  has_one :trip_activity, :as =>:activity
  attr_accessible :activity_id, :destination, :duration, :source, :transport_quick_tips, :transport_type_id
end
