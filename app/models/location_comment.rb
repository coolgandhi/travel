class LocationComment < ActiveRecord::Base
  attr_accessible :created_time, :follow_post_id, :location_detail_id, :log, :name, :photo, :source, :summary, :url
  belongs_to :location_detail, :foreign_key => :location_detail_id
end
