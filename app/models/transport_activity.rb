class TransportActivity < ActiveRecord::Base
  has_one    :trip, :through => :trip_activities
  has_one :trip_activity, :as =>:activity
  attr_accessible :activity_id, :destination, :duration, :source, :transport_quick_tips, :transport_type_id
  validates :source, :presence => { :message => "enter source" }
  validates :destination, :presence => { :message => "enter destination" }
  validates :duration, :presence => { :message => "enter activity duration" }
  validates_numericality_of :duration, :message => "enter a valid duration" 
end
