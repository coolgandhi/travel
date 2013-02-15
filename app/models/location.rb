class Location < ActiveRecord::Base
  attr_accessible :city, :country, :latitude, :location_id, :longitude, :place, :state
  has_many :trips, :primary_key => :location_id
  validates_uniqueness_of :location_id, :message => "location already present"
end
