module TripsHelper

  # this helper provides the view with an arrary of trip and all activities
  def sorted_trip_activities trip
    trip_location = trip.location[:place]
    trip_activities = trip.trip_activities
    
    # food_activities = TripActivity.find_by_sql(["SELECT trip_activities.*, food_activities.*, restaurant_details.*, activity_duration_types.* FROM trip_activities, food_activities,  restaurant_details, activity_duration_types WHERE (trip_activities.activity_type = \"FoodActivity\" and  food_activities.id = trip_activities.activity_id and food_activities.duration = activity_duration_types.activity_duration_type_id and trip_activities.trip_id = ? and restaurant_details.restaurant_detail_id = food_activities.restaurant_detail_id)", trip.id])
    
    mapped_activities = Array.new
    trip_activities.each {|trip_activity| 
        image_url = ""
        activity_venue_name = ""
        lay_out = ""
        category = ""
        duration = ""
        activity = nil
        case trip_activity.activity_type 
            when "FoodActivity" then 
              activity = FoodActivity.find(trip_activity.activity_id, :include => [:restaurant_detail, :activity_duration_type], :select => "food_activity.*, restaurant_detail.*, activity_duration_type.*")
              # image_url = trip_activity.activity.restaurant_detail[:image_urls]   
              #       activity_venue_name = trip_activity.activity.restaurant_detail[:name]
              #       category = trip_activity.activity.restaurant_detail[:category]
              #       duration = (trip_activity.activity.activity_duration_type)? trip_activity.activity.activity_duration_type[:activity_duration_name] : trip_activity.activity[:duration]
              image_url = activity.restaurant_detail.image_urls
              activity_venue_name = activity.restaurant_detail.name
              category = activity.restaurant_detail.category
              duration = (activity.activity_duration_type)? activity.activity_duration_type[:activity_duration_name] : activity.duration
              lay_out = "foodactivitypartial"
            when "LocationActivity" then 
              # image_url = trip_activity.activity.location_detail[:image_urls]
              #               activity_venue_name = trip_activity.activity.location_detail[:name]
              #               category = trip_activity.activity.location_detail[:category]
              #               duration = (trip_activity.activity.activity_duration_type)? trip_activity.activity.activity_duration_type[:activity_duration_name] : trip_activity.activity[:duration]
              activity = LocationActivity.find(trip_activity.activity_id, :include => [:location_detail, :activity_duration_type], :select => "location_activity.*, location_detail.*, activity_duration_type.*")
              image_url = activity.location_detail.image_urls
              activity_venue_name = activity.location_detail.name
              category = activity.location_detail.category
              duration = (activity.activity_duration_type)? activity.activity_duration_type[:activity_duration_name] : activity.duration
              lay_out = "locationactivitypartial"
            else  # default transport activity
              image_url = ""
              activity_venue_name = ""
              category = ""
              lay_out= "transportactivitypartial"
        end
      
        if activity.image_urls and activity.image_urls != "" 
          image_url = activity.image_urls # select image from the activity if chosen by the author
        end
        
        mapped_activities.push (
          { 
            :activityday => trip_activity.activity_day, 
            :activitysequence => trip_activity.activity_sequence_number, 
            :activityid => trip_activity.id,
            :activitytype => trip_activity.activity_type,
            :tripname => trip.trip_name,
            :triplength => trip.duration, 
            :triplocation => trip_location, 
            :tripid =>  trip.id,
            :rightcaption => activity.description, 
            :quicktip => activity.quick_tip, 
            :duration => duration,
            :timetype => trip_activity.activity_time_type,
            :category => category,
            :image_url => image_url,
            :activity_venue_name => activity_venue_name,
            :renderpartial => "/trips/#{trip.id}/trip_activities/#{trip_activity.id}/showpartial", 
            :layout => lay_out   
          }
        )             
    }

    # # sorting this JSON by sequence number
    sorted_activities = mapped_activities.sort {|j, k| 
        f = ((j[:activityday].nil? or j[:activityday] == "") ? 0 : j[:activityday].to_i)
        g = (j[:activitysequence].nil? ) ? 0: j[:activitysequence]
        h = ((k[:activityday].nil? or k[:activityday] == "") ? 0 : k[:activityday].to_i)
        i = (k[:activitysequence].nil?) ? 0: k[:activitysequence]
        # logger.info "#{f}, #{g}.. #{h}, #{i} .... \n"
        [f, g] <=> [h, i]
      }


    sorted_activities.push({renderpartial: "/trips/#{trip.id}/showpartial/", layout: "about_author"})
    
    compressed_activities = Array.new
    sorted_activities.each { |sorted_activity|
      compressed_activities.push (
        {
          :activityid => sorted_activity[:activityid],
          :renderpartial => sorted_activity[:renderpartial],
          :layout => sorted_activity[:layout],
          :timetype => sorted_activity[:timetype],
          :tripid => sorted_activity[:tripid],
          :activityday => sorted_activity[:activityday]
        }
      )
    }
    
    return sorted_activities, compressed_activities
  end


  def avatar_url(author)  
    gravatar_id = Digest::MD5::hexdigest(author.email).downcase  
    "http://gravatar.com/avatar/#{gravatar_id}.png"  
  end  

  def traveler_type_badge_class(traveler)
    case traveler
    when "Solo Traveller" then 
      'solo-badge'
    when "Couple" then 
      'couples-badge'
    when "Family" then 
      'family-badge'
    when "Group" then 
      'group-badge'
    else  # girlsgetaway and backpacker
      'other-badge'
    end
  end

  def get_trips_filtered_by_landmarks params, trips, message_with_trip_render, exact_match_count_passed_in
    if (params[:restaurant])
      trip_restaurants = []
      restaurant = RestaurantDetail.find_by_restaurant_detail_id(params[:restaurant])
      food_activities = restaurant.food_activities
      food_activities.each { |food_activity|
        trip_restaurants.push(food_activity.trip_activity.trip)
      }
   
      trips = trip_restaurants & trips
      if trips.length == 0 # find trips from same location as a minimum 
        message_with_trip_render = "Find the trips that includes #{restaurant.name}."
        trips = trip_restaurants
      else
        message_with_trip_render =  "Found #{trips.length} trip summaries that matched your criteria."
      end
    end

    if (params[:location])
      trip_locations = []
      location = LocationDetail.find_by_location_detail_id(params[:location])
      location_activities = location.location_activities
      location_activities.each { |location_activity|
        trip_locations.push(location_activity.trip_activity.trip)
      }

      trips = trip_locations & trips
      if trips.length == 0  # find trips from same location as a minimum 
       message_with_trip_render = "Find the trips that includes #{location.name}."
       trips = trip_locations
      else
        message_with_trip_render =  "Found #{trips.length} trip summaries that matched your criteria"
      end
    end
    
    return trips, exact_match_count_passed_in, message_with_trip_render
  end
end
