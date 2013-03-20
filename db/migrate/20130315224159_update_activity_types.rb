class UpdateActivityTypes < ActiveRecord::Migration
  def up
    # @food = TripActivity.find_by_activity_type_id('1')
    # @food.each do |f|
    #   f.update_attribute(:activity_type_id, 'FoodActivity')
    # end
    # 
    # @transport = TripActivity.find_by_activity_type_id('2')
    # @transport.each do |f|
    #   f.update_attribute(:activity_type_id, 'TransportActivity')
    # end
    # 
    # @location = TripActivity.find_by_activity_type_id('3')
    # @location.each do |f|
    #   f.update_attribute(:activity_type_id, 'LocationActivity')
    # end
    ActivityType.connection.execute("update activity_types set activity_type_id='FoodActivity' where activity_type_id='1'")
    ActivityType.connection.execute("update activity_types set activity_type_id='TransportActivity' where activity_type_id='2'")
    ActivityType.connection.execute("update activity_types set activity_type_id='LocationActivity' where activity_type_id='3'")
    
    TripActivity.connection.execute("update trip_activities set activity_type='FoodActivity' where activity_type='1'")
    TripActivity.connection.execute("update trip_activities set activity_type='TransportActivity' where activity_type='2'")
    TripActivity.connection.execute("update trip_activities set activity_type='LocationActivity' where activity_type='3'")
  end

  def down
  end
end
