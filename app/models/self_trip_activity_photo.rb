class SelfTripActivityPhoto < ActiveRecord::Base
  attr_accessible :trip_activity_id, :self_photo, :self_photo_tmp
  belongs_to :trip_activity, :foreign_key => :trip_activity_id
  mount_uploader :self_photo, ImageUploader
  store_in_background :self_photo
end
