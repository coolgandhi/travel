class Location < ActiveRecord::Base
  attr_accessible :city, :country, :latitude, :location_id, :longitude, :place, :state
end
