class FoodActivity < ActiveRecord::Base
  belongs_to :trip_activity
  attr_accessible :activity_id, :description, :duration, :quick_tip, :restaurant_detail_id
end
