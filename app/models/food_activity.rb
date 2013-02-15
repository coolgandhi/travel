class FoodActivity < ActiveRecord::Base
 # belongs_to :trip_activity
  belongs_to :restaurant_detail, :primary_key => :restaurant_detail_id
  has_one    :trip, :through => :trip_activities
  has_one :trip_activity, :as =>:activity
  attr_accessible :activity_id, :description, :duration, :quick_tip, :restaurant_detail_id, :image_urls
  validates :description, :presence => {:message => "enter activity description" }, :length => { :minimum => 2, :maximum => 200, :too_short => "activity description must have at least %{count} characters", :too_long  => "activity description can have at most %{count} characters" }
  validates :quick_tip, :presence => {:message => "enter activity tip" }, :length => { :minimum => 2, :maximum => 140, :too_short => "activity description must have at least %{count} characters", :too_long  => "activity description can have at most %{count} characters" }
  validates :duration, :presence => {:message => "enter activity duration" }
  validates_numericality_of :duration, :message => "enter a valid duration" 
  validates :restaurant_detail_id, :presence => {:message => "enter location" }
end
