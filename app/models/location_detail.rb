class LocationDetail < ActiveRecord::Base
  attr_accessible :location_detail_id, :address1, :address2, :address3, :category, :city, :country, :description, :latitude, :longitude, :name, :open_hours, :phone, :state, :website, :zip, :image_urls, :location_id, :rating, :twitter, :canonical_url, :source
  has_many :location_activities, :primary_key => :location_detail_id
  has_many :location_comments, :primary_key => :location_detail_id, :dependent => :destroy 
  validates_uniqueness_of :location_detail_id, :message => "location already present"
  
  
  def self.search location_id
  #  result = LocationDetail.select("location_details.*, COUNT(*) AS location_count").find(:conditions => "location_id = ?", location_id).join(:location_activities).group(:location_id).order("location_count DESC")
    LocationDetail.find(:all, :conditions => ["location_id = ?", location_id], :joins => :location_activities, :select => "location_details.*, COUNT(*) AS location_count", :group => :location_detail_id, :order => "location_count DESC")
  end
end
