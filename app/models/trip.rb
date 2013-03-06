class Trip < ActiveRecord::Base
  attr_accessible :trip_id, :author_id, :duration, :location_id, :traveler_type_id, :trip_name, :trip_summary, :image_url
  has_many :trip_comments, :dependent => :destroy
  has_many :trip_activities, :dependent => :destroy
  has_one  :trip_stat, :dependent => :destroy
  has_many :food_activities, :through => :trip_activities, :source => :activity, :source_type => 'FoodActivity', :dependent => :destroy
  has_many :location_activities, :through => :trip_activities, :source => :activity, :source_type => 'LocationActivity', :dependent => :destroy
  has_many :transport_activities, :through => :trip_activities, :source => :activity, :source_type => 'TransportActivity', :dependent => :destroy
  belongs_to :location, :primary_key => :location_id
  belongs_to :traveler_type, :primary_key => :traveler_type_id
  belongs_to :author_info, :foreign_key => :author_id

  validates :author_id, :presence => { :message => "" }
  validates :location_id, :presence => { :message => "choose a location" }
  validates :trip_name, :presence => { :message => "enter trip name" }, :length => { :minimum => 2, :maximum => 100, :too_short => "trip name must have at least %{count} characters in the trip name", :too_long  => "trip name can have at most %{count} characters" }
  validates :trip_summary, :presence => { :message => "enter trip summary" }, :length => { :minimum => 2, :maximum => 250, :too_short => "trip summary must have at least %{count} characters", :too_long  => "trip summary can have at most %{count} characters" }
  validates :duration, :presence => { :message => "enter a valid duration for the trip" }
  validates_numericality_of :duration, :message => "enter a valid length of the trip" 
  
  
  def self.search params
    message_with_trip_render = " Check out your trips! "
    if (params[:trip_location_id] and params[:trip_location_id] != "")
      # duration = (DateTime.strptime(params[:to], "%m/%d/%Y") - DateTime.strptime(params[:from], "%m/%d/%Y"))
      duration = params[:days]
      trips = Trip.where("location_id = ? and traveler_type_id IN (?) and duration >= ? and duration <= ?", params[:trip_location_id], params[:traveler_type_id], duration.to_i.to_s, duration.to_i.to_s)
      
      if trips.length == 0 # find trips from same location as a minimum 
        trips = Trip.where("location_id = ?", params[:trip_location_id])
        message_with_trip_render = "Can't find the trips with the specified constraints, check out these other trips to the same location"
      end
      return trips, message_with_trip_render
    else
      return scoped, message_with_trip_render
    end
   end

end
