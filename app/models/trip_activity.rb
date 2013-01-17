class TripActivity < ActiveRecord::Base
  belongs_to :trip
  has_one :food_activity, :dependent => :destroy
  has_one :location_activity, :dependent => :destroy
  has_one :transport_activity, :dependent => :destroy
  
  accepts_nested_attributes_for :food_activity, :allow_destroy => true
  accepts_nested_attributes_for :location_activity, :allow_destroy => true
  accepts_nested_attributes_for :transport_activity, :allow_destroy => true
  
  attr_accessible :trip_id, :activity_day, :activity_id, :activity_sequence_number, :activity_time_type, :activity_type

  def next
  	trip.trip_activities.where("activity_sequence_number > ?", activity_sequence_number).first
  end

  def prev
  	trip.trip_activities.where("activity_sequence_number < ?", activity_sequence_number).first
  end

end
