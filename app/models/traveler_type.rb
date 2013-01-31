class TravelerType < ActiveRecord::Base
  attr_accessible :traveler_type_id, :traveler_type_name
  has_many :trips, :primary_key => :traveler_type_id
end
