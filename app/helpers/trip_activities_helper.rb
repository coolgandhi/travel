module TripActivitiesHelper
  def get_trip_map_info trip_activities_info
    trip_map_info = Array.new
    i = 0;
    trip_activities_info.each { |trip_activity|
        case trip_activity.activity_type
          when "FoodActivity" 
            #logger.info "\n\n\\nhere... #{trip_activity.activity_id.inspect}\n\n\n"
            
            # logger.info " #{trip_activity.activity.restaurant_detail[:name].inspect}"
            
            if trip_activity.activity.restaurant_detail
              trip_map_info[i] =  { name: trip_activity.activity.restaurant_detail[:name],
                                    location: trip_activity.activity.restaurant_detail[:latitude] + "," + trip_activity.activity.restaurant_detail[:longitude],
                                    logo: "food.png" 
                                  }
              i = i + 1
            end
          when "TransportActivity"
            # do nothing
          when "LocationActivity"     
            if trip_activity.activity.location_detail
              trip_map_info[i] =  { name: trip_activity.activity.location_detail[:name],
                                    location: trip_activity.activity.location_detail[:latitude] + "," + trip_activity.activity.location_detail[:longitude],
                                    logo: "location.png" 
                                  }
              i = i + 1
            end
        end
      } 
    trip_map_info
  end
end
