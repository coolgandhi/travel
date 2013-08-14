class Trip < ActiveRecord::Base
  attr_accessible :trip_id, :author_id, :duration, :location_id, :traveler_type_id, :trip_name, :trip_summary, :image_url, :featured_trip_flag, :rank_score, :self_image, :self_image_tmp, :tags, :share_status
  has_many :trip_comments, :dependent => :destroy
  has_many :trip_activities, :dependent => :destroy
  has_many  :trip_feedbacks
  has_one  :trip_stat, :dependent => :destroy
  has_many :food_activities, :through => :trip_activities, :source => :activity, :source_type => 'FoodActivity', :dependent => :destroy
  has_many :location_activities, :through => :trip_activities, :source => :activity, :source_type => 'LocationActivity', :dependent => :destroy
  has_many :transport_activities, :through => :trip_activities, :source => :activity, :source_type => 'TransportActivity', :dependent => :destroy
  belongs_to :location, :primary_key => :location_id
  belongs_to :traveler_type, :primary_key => :traveler_type_id
  belongs_to :author_info, :foreign_key => :author_id

  mount_uploader :self_image, ImageUploader
  store_in_background :self_image
  
  validates :author_id, :presence => { :message => "please check if you are signed in" }
  validates :location_id, :presence => { :message => "choose a location" }
  validates :trip_name, :presence => { :message => "enter trip name" }, :length => { :minimum => 2, :maximum => 40, :too_short => "trip name must have at least %{count} characters in the trip name", :too_long  => "trip name can have at most %{count} characters" }
  validates :trip_summary, :presence => { :message => "enter trip summary" }, :length => { :minimum => 2, :maximum => 200, :too_short => "trip summary must have at least %{count} characters", :too_long  => "trip summary can have at most %{count} characters" }
  #validates :duration, :presence => { :message => "enter a valid duration for the trip" }
  validates_numericality_of :duration, :message => "enter a valid length of the trip" 
  validates :rank_score, :numericality => {:greater_than_or_equal_to => 0, :less_than_or_equal_to => 100, :message => "score should be between 0 and 100"}
  
  extend FriendlyId
  friendly_id :trip_name, use: [:slugged, :history] 

#  def should_generate_new_friendly_id?
#    new_record?
#  end

  def days_in_trip
    self.trip_activities.order("trip_activities DESC").maximum(:activity_day)
  end
  
  def self.search_by_location location_id, feature_flag, total
    query = "share_status = 1  "
    query +=  "and featured_trip_flag = " + feature_flag 
    query += " and location_id = " + location_id
    trips = Trip.where( query ).order("rank_score DESC").limit(total)
    return trips  
  end
  
  def self.search params, find_exact_match_only
    message_with_trip_render = ""
    exact_match_count = 0
    if ((params[:trip_location_id] and params[:trip_location_id] != "") )
      # duration = (DateTime.strptime(params[:to], "%m/%d/%Y") - DateTime.strptime(params[:from], "%m/%d/%Y"))
      duration = params[:days]
      query = "share_status = 1 and "
      query += (params[:trip_location_id] and params[:trip_location_id] != "")? " location_id IN ( " + params[:trip_location_id] + ") and " : ""
      query += (params[:traveler_type_id] and params[:traveler_type_id] != "")? "traveler_type_id IN (" + params[:traveler_type_id].join(" , ") + ") and " : "" 
      query += (duration and duration != "") ? " duration >= " + duration.to_i.to_s + " and duration <= " + duration.to_i.to_s + " and " : "" 
      query += (params[:featured])? " featured_trip_flag = " + params[:featured]  : " featured_trip_flag is NOT NULL" 
      
      trips = Trip.where( query ).order("rank_score DESC")
#      trips = Trip.where("location_id IN (?) and traveler_type_id IN (?) and duration >= ? and duration <= ? and featured_trip_flag = ?", params[:trip_location_id], (params[:traveler_type_id])?params[:traveler_type_id] : "select traveler_type_id from traveler_types", duration.to_i.to_s, duration.to_i.to_s, (params[:featured_trip_flag])?params[:featured_trip_flag] : false)
      if trips.length > 0
        exact_match_count = trips.length
        if trips.length > 3
          message_with_trip_render = "Found #{trips.length} trip summaries that matched your criteria."
        else
          message_with_trip_render = "First #{trips.length} trip summaries matched your criteria."
        end
      end
      
      if trips.length < 3 and find_exact_match_only == false # find trips from same location as a minimum 
        
        order_by = (!params[:traveler_type_id].blank?) ? "  FIELD(traveler_type_id, " + params[:traveler_type_id].join(" , ") + ") DESC, " : "" 
        trips_notmatch = Trip.where("share_status = 1 and location_id = ?", params[:trip_location_id]).order(order_by + " rank_score DESC")
        if trips.length == 0
          message_with_trip_render = "None of the trip summaries matched your specific criteria. Showing other trip summaries to #{params["place_text_field"].split(/,/).first}."
        else
          message_with_trip_render += " Added other trip summaries to  #{params["place_text_field"].split(/,/).first} as well."
        end
        if trips_notmatch.length == trips.length
          message_with_trip_render = "Found #{trips.length} trip summaries that matched your criteria."
        end
        
        trips = ( trips + trips_notmatch ).uniq
        if trips.length == 0
          message_with_trip_render = "None of the trip summaries matched your criteria."
        end
      end
      
      return trips, exact_match_count, message_with_trip_render
    else
      return scoped(:conditions => 'share_status = 1', :limit => exact_match_count.to_i), exact_match_count, message_with_trip_render
    end
   end

end
