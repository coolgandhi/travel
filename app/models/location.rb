class Location < ActiveRecord::Base
  attr_accessible :city, :country, :latitude, :location_id, :longitude, :place, :state
  has_many :trips, :primary_key => :location_id
end
