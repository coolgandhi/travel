class Trip < ActiveRecord::Base
  attr_accessible :trip_id, :author_id, :duration, :location_id, :traveler_type_id, :trip_name, :trip_summary
  has_many :trip_comments, :dependent => :destroy
  has_many :trip_activities, :dependent => :destroy
  has_one  :trip_stat, :dependent => :destroy
  has_many :food_activities, :through => :trip_activities, :source => :activity, :source_type => 'FoodActivity', :dependent => :destroy
  has_many :location_activities, :through => :trip_activities, :source => :activity, :source_type => 'LocationActivity', :dependent => :destroy
  has_many :transport_activities, :through => :trip_activities, :source => :activity, :source_type => 'TransportActivity', :dependent => :destroy
  
#  has_many :location_activities
#  has_many :transport_activities
end
