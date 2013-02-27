class LocationDetail < ActiveRecord::Base
  attr_accessible :location_detail_id, :address1, :address2, :address3, :category, :city, :country, :description, :latitude, :longitude, :name, :open_hours, :phone, :state, :website, :zip, :image_urls, :location_id
  has_many :location_activities, :primary_key => :location_detail_id
  validates_uniqueness_of :location_detail_id, :message => "location already present"
  
  
  def self.search location_id
    LocationDetail.where("location_id = ?", location_id)
  end
end
