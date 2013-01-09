class TripActivity < ActiveRecord::Base
  belongs_to :trip
  has_one :food_activity, dependent => :destroy
  has_one :location_activity, dependent => :destroy
  has_one :transport_activity, dependent => :destroy
  attr_accessible :trip_id, :activity_day, :activity_id, :activity_sequence_number, :activity_time_type, :activity_type
end
