class Trip < ActiveRecord::Base
  has_many :trip_activities, dependent => :destroy 
  has_many :trip_comments, dependent => :destroy
  has_one  :trip_stat, dependent => :destroy
  attr_accessible : trip_id, :author_id, :duration, :location_id, :traveler_type_id, :trip_name, :trip_summary
end
