class TripComment < ActiveRecord::Base
  belongs_to :trip
  attr_accessible :comment, :trip_id
end
