class UpdateTripActivityTypeAssociationsInTripActivities < ActiveRecord::Migration
  def up
    @food = TripActivity.find_all_by_activity_type(['1'])
    @food.each do |f|
      f.update_attribute(:activity_type, 'FoodActivity')
    end
    
    @transport = TripActivity.find_all_by_activity_type(['2'])
    @transport.each do |f|
      f.update_attribute(:activity_type, 'TransportActivity')
    end
    
    @location = TripActivity.find_all_by_activity_type(['3'])
    @location.each do |f|
      f.update_attribute(:activity_type, 'LocationActivity')
    end
  end

  def down
  end
end
