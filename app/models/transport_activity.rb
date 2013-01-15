class TransportActivity < ActiveRecord::Base
  belongs_to :trip_activity
  attr_accessible :activity_id, :destination, :duration, :source, :transport_quick_tips, :transport_type_id
end
