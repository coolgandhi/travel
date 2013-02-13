class TripActivity < ActiveRecord::Base
  belongs_to :trip
  belongs_to :activity,  :polymorphic => true
#  has_one :food_activity, :dependent => :destroy
 # has_one :location_activity, :dependent => :destroy
#  has_one :transport_activity, :dependent => :destroy
  
#  accepts_nested_attributes_for :food_activity, :allow_destroy => true
#  accepts_nested_attributes_for :location_activity, :allow_destroy => true
#  accepts_nested_attributes_for :transport_activity, :allow_destroy => true
  belongs_to :activity_time_types, :primary_key => :activity_time_type_id
  attr_accessible :activity, :trip_id, :activity_day, :activity_id, :activity_sequence_number, :activity_time_type, :activity_type

  def next
  	trip.trip_activities.where("activity_sequence_number > ?", activity_sequence_number).first
  end

  def prev
  	trip.trip_activities.where("activity_sequence_number < ?", activity_sequence_number).first
  end

  def prev_activities_sequence_number
    day = (activity_day.nil? or activity_day == "") ? "0" : activity_day
    sequence = (activity_sequence_number.nil? ) ? 0: activity_sequence_number
  	trip.trip_activities.where("activity_sequence_number <= ? and activity_day = ?", sequence, day).order(:activity_sequence_number)
  end

  def prev_activities_activity_id
  	trip.trip_activities.where("id <= ?", id).order(:id)
  end

end
