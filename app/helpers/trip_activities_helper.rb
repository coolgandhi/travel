module TripActivitiesHelper

  # this checks to see if a detail (i.e. open hours) is avaialble, if not then just post a empty string rather than nothing at all
  def check_empty_detail(attribute)
    attribute.blank? ? "--" : attribute
  end
  
  # This function gets the image that we want to show on an activity card
  # index details which image to pick if multiple images
  def select_activity_img(activity_id, image_urls, width, index = 0)
    if activity_id != -1
      if activity_id.activity.image_urls.nil? or activity_id.activity.image_urls == ""
        case 
            when activity_id.activity_type == "FoodActivity" then image_urls = activity_id.activity.restaurant_detail[:image_urls]
            when activity_id.activity_type == "LocationActivity" then image_urls = activity_id.activity.location_detail[:image_urls]
            else image_urls = ""
        end
      else
        image_urls = activity_id.activity.image_urls # select image from the activity if chosen by the author
      end
    end
    
    
    image = select_image_given_image_urls(image_urls, width, index)
      #z is in the format of
        #[["https://is1.4sqi.net/pix/77727_kohZm1hN4NDZ6kQVznu7SGUkWk7NeJz6W9Xwa_heiqk.jpg", "612X612", "https://is0.4sqi.net/derived_pix/77727_kohZm1hN4NDZ6kQVznu7SGUkWk7NeJz6W9Xwa_heiqk_300x300.jpg", "300X300", "https://is0.4sqi.net/derived_pix/77727_kohZm1hN4NDZ6kQVznu7SGUkWk7NeJz6W9Xwa_heiqk_100x100.jpg", "100X100", "https://is0.4sqi.net/derived_pix/77727_kohZm1hN4NDZ6kQVznu7SGUkWk7NeJz6W9Xwa_heiqk_36x36.jpg", "36X36"],...]
        #z[picture][size]. odd index numbers are the dimensions and even are urls to the right size in descending size order
  end

  # This function gets the appropriate thumbnail for the filmstrip
  def show_thumbnail(i, width)
    if @sorted_activities[i][:activityid]
      activity_id = @sorted_activities[i][:activityid]
      image_url = select_activity_img(-1, @sorted_activities[i][:image_url], width) 
    else
      "/assets/no-img-holder.png"
    end
  end

  # This function gets the name of the activity venue for the thumbnail captions
  def thumbnail_name(i)
    if @sorted_activities[i][:activityid]
      thumb_name = @sorted_activities[i][:activity_venue_name]
      thumb_name
    else
      ""
    end
  end

  def alt_name_card_image(activity_id)
    this_activity = TripActivity.find(activity_id)
    activity_type = this_activity.activity_type
    case 
        when activity_type == "FoodActivity" then alt_name = this_activity.activity.restaurant_detail[:name]
        when activity_type == "TransportActivity" then alt_name = this_activity.activity.location_detail[:name]
        # when activity_id.activity_type == "LocationActivity" then alt_name = activity_id.activity.transport_detail[:name]
    end
    alt_name
  end
  
  def get_trip_map_info(trip_activities_info, current_activity)
    logger.info { "\n\n\n\ntripdetails...  #{current_activity}"}
    trip_map_info = Array.new
    i = 0;
    trip_activities_info.each { |trip_activity|
        case trip_activity.activity_type
          when "FoodActivity" 
            if trip_activity.activity.restaurant_detail
              trip_map_info[i] =  { name: "<b>" + trip_activity.activity.restaurant_detail[:name] + "</b>",
                                    address: "<address>" + check_empty_detail(trip_activity.activity.restaurant_detail[:address1])+ "<br>" + check_empty_detail(trip_activity.activity.restaurant_detail[:city])+ ", " + check_empty_detail(trip_activity.activity.restaurant_detail[:state]) + " " + check_empty_detail(trip_activity.activity.restaurant_detail[:zip]) + "</address>",
                                    location: trip_activity.activity.restaurant_detail[:latitude] + "," + trip_activity.activity.restaurant_detail[:longitude],
                                    logo: trip_activity.id.to_i == current_activity.to_i ? "map-markers-red-food.png" : "map-markers-blue-food.png"
                                  }
              i = i + 1
            end
          when "TransportActivity"
            # do nothing
          when "LocationActivity"     
            if trip_activity.activity.location_detail
              trip_map_info[i] =  { name: "<b>" + trip_activity.activity.location_detail[:name] + "</b>",
                                    address: "<address>" + check_empty_detail(trip_activity.activity.location_detail[:address1])+ "<br>" + check_empty_detail(trip_activity.activity.location_detail[:city])+ ", " + check_empty_detail(trip_activity.activity.location_detail[:state]) + " " + check_empty_detail(trip_activity.activity.location_detail[:zip])  + "</address>",
                                    location: trip_activity.activity.location_detail[:latitude] + "," + trip_activity.activity.location_detail[:longitude],
                                    logo: trip_activity.id.to_i == current_activity.to_i ? "map-markers-red-location.png" : "map-markers-blue-location.png"
                                  }
              i = i + 1
            end
        end
      } 
    trip_map_info
  end

  def which_detail_type(activity_var, detail)
  	which_detail = case activity_var.activity_type 
  		when "FoodActivity"
  			"restaurant_detail"
  		when "TransportActivity"
  			# do nothing
  		when "LocationActivity"
  			"location_detail"
  		end
  	#send allows calling of method as a string on the receiver. 	
  	activity_var.activity.send("#{which_detail}").send(detail.to_sym)
  end

end
