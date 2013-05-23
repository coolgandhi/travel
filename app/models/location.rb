class Location < ActiveRecord::Base
  attr_accessible :city, :country, :latitude, :location_id, :longitude, :place, :state
  has_many :trips, :primary_key => :location_id
  validates_uniqueness_of :location_id, :message => "location already present"

  def location_label
    temp_label = ""
    temp_label = self.city.blank? ? temp_label : temp_label + "#{self.city}"
    temp_label = self.state.blank? ? temp_label : temp_label + ", #{self.state}"
    temp_label = self.country.blank? ? temp_label : temp_label + ", #{self.country}"
  end
end
