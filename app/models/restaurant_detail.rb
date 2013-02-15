class RestaurantDetail < ActiveRecord::Base
  attr_accessible :restaurant_detail_id, :address1, :address2, :address3, :category, :city, :country, :description, :latitude, :longitude, :name, :open_hours, :phone, :state, :website, :zip, :image_urls
  has_many :food_activities, :primary_key => :restaurant_detail_id
  validates_uniqueness_of :restaurant_detail_id, :message => "restaurant already present"
end
