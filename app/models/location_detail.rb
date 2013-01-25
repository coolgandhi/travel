class LocationDetail < ActiveRecord::Base
  attr_accessible :location_detail_id, :address1, :address2, :address3, :category, :city, :country, :description, :latitude, :longitude, :name, :open_hours, :phone, :state, :website, :zip
  has_many :location_activities, :primary_key => :location_detail_id
end
