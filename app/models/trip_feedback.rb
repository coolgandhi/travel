class TripFeedback < ActiveRecord::Base
  belongs_to :trip
  attr_accessible :feedback, :trip_id
end
