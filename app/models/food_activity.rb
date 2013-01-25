class FoodActivity < ActiveRecord::Base
 # belongs_to :trip_activity
  belongs_to :restaurant_detail, :primary_key => :restaurant_detail_id
  has_one    :trip, :through => :trip_activities
  has_one :trip_activity, :as =>:activity
  attr_accessible :activity_id, :description, :duration, :quick_tip, :restaurant_detail_id
end
