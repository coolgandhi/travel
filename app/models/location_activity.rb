class LocationActivity < ActiveRecord::Base
  belongs_to :location_detail, :primary_key => :location_detail_id
  has_one    :trip, :through => :trip_activities
  has_one :trip_activity, :as =>:activity
  has_one :activity_duration_type, :primary_key => :duration, :foreign_key => :activity_duration_type_id
  
  attr_accessible :activity_id, :description, :duration, :location_detail_id, :quick_tip, :image_urls
  validates :description, :presence => {:message => "enter activity description" }, :length => { :minimum => 2, :maximum => 200, :too_short => "activity description must have at least %{count} characters", :too_long  => "activity description can have at most %{count} characters" }
  validates :quick_tip, :length => { :minimum => 0, :maximum => 140, :too_short => "activity description must have at least %{count} characters", :too_long  => "activity description can have at most %{count} characters" } #:presence => {:message => "enter activity tip" } 
  validates :duration, :presence => {:message => "enter activity duration" }
  validates_numericality_of :duration, :message => "enter a valid duration" 
  validates :location_detail_id, :presence => {:message => "enter location" }
end
