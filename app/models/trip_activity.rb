class TripActivity < ActiveRecord::Base
  acts_as_list :column => :activity_sequence_number
  belongs_to :trip
  belongs_to :activity,  :polymorphic => true
  belongs_to :activity_time_types, :primary_key => :activity_time_type_id
  has_many :self_trip_activity_photos, :primary_key => :id, :dependent => :destroy 
  accepts_nested_attributes_for :self_trip_activity_photos 
  
  attr_accessible :activity, :trip_id, :activity_day, :activity_id, :activity_sequence_number, :activity_time_type, :activity_type

  validates :activity, :presence => { :message => "" } 
  validates :activity_day, :presence => { :message => "choose an activity day" } 
  validates_numericality_of :activity_day, :only_integer => true, :message => "enter a valid day" 
  validates :activity_time_type, :presence => { :message => "choose the activity time" }
  validates :activity_sequence_number, :presence => { :message => "enter activity sequence" }
  validates_numericality_of :activity_sequence_number, :only_integer => true, :message => "enter a valid sequence number" 
  validates :activity_type, :presence => { :message => "enter activity type" }
  
  # validates_uniqueness_of :trip_id, :scope => [:activity_day, :activity_sequence_number], :message => "trip with same activity day and sequence number already present"

  # scope_condition for acts_as_list
  def scope_condition
    "trip_id = #{trip_id} AND activity_day = #{activity_day}"
  end
  
  def max_sequence_number_day day
  #  trip.trip_activities.where("activity_day = ?", day).maximum(:activity_sequence_number)
    trip.trip_activities.maximum(:activity_sequence_number)    
  end
  
  def prev_activities_sequence_number
    day = (activity_day.nil? or activity_day == "") ? "0" : activity_day
    sequence = (activity_sequence_number.nil? ) ? 0: activity_sequence_number
  	# trip.trip_activities.where("activity_sequence_number <= ? and activity_day = ?", sequence, day).order(:activity_sequence_number)
    trip.trip_activities.where("activity_day = ?", day).order(:activity_sequence_number)
  end

end
