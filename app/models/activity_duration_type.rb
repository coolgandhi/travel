class ActivityDurationType < ActiveRecord::Base
  attr_accessible :activity_duration_name, :activity_duration_type_id
  belongs_to :food_activity, :primary_key => :activity_duration_type_id
  belongs_to :location_activity, :primary_key => :activity_duration_type_id
end
