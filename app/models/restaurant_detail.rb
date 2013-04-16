class RestaurantDetail < ActiveRecord::Base
  attr_accessible :restaurant_detail_id, :address1, :address2, :address3, :category, :city, :country, :description, :latitude, :longitude, :name, :open_hours, :phone, :state, :website, :zip, :image_urls, :location_id, :rating, :twitter, :source
  has_many :food_activities, :primary_key => :restaurant_detail_id
  has_many :restaurant_comments, :primary_key => :restaurant_detail_id, :dependent => :destroy 
  validates_uniqueness_of :restaurant_detail_id, :message => "restaurant already present"
  
  
  def self.search location_id
    #RestaurantDetail.where("location_id = ?", location_id)
    
    RestaurantDetail.find(:all, :conditions => ["location_id = ?", location_id], :joins => :food_activities, :select => "restaurant_details.*, COUNT(*) AS restaurant_count", :group => :restaurant_detail_id, :order => "restaurant_count DESC")
  end
end
