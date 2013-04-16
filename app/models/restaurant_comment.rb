class RestaurantComment < ActiveRecord::Base
  attr_accessible :created_time, :follow_post_id, :log, :name, :photo, :restaurant_detail_id, :source, :summary, :url
  belongs_to :restaurant_detail, :foreign_key => :restaurant_detail_id
end
