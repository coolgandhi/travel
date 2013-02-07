module TripActivitiesHelper

  # this checks to see if a detail (i.e. open hours) is avaialble, if not then just post a empty string rather than nothing at all
  def check_empty_detail(attribute)
    attribute == "" ? "--" : attribute
  end

  def select_closest_image(images, width)
    image = ""
    index = 0
    while index < images.length
      y = images[index + 1].to_s.split("X")
      if (((width + 50) >  y[0].to_i) and (y[0].to_i > (width - 50)))
        image = images[index]
        break
      end
      index = index + 2
    end
    
    if image == ""
      if image.length > 2
        image = images[2] # always return the second sized image,  best case effort if available
      else
        image = images[0]
      end
    end
    
    image
  end
  
  # This function gets the image that we want to show on an activity card
  def select_activity_img(activity_id, width, index = 0)
    if activity_id.activity.image_urls.nil? or activity_id.activity.image_urls == ""
      case 
          when activity_id.activity_type == "FoodActivity" then x = activity_id.activity.restaurant_detail[:image_urls]
          when activity_id.activity_type == "TransportActivity" then x = activity_id.activity.location_detail[:image_urls]
          else x = ""
      end
    else
      x = activity_id.activity.image_urls # select image from the activity if chosen by the author
    end

    y = x.to_s.split(";")
    if index < y.length
      y = y[index]
    elsif y.length > 0
      y = y[0]
    else
      return ""
    end
    
    z = y.split(",")  
    image = select_closest_image(z, width)
      #z is in the format of
        #[["https://is1.4sqi.net/pix/77727_kohZm1hN4NDZ6kQVznu7SGUkWk7NeJz6W9Xwa_heiqk.jpg", "612X612", "https://is0.4sqi.net/derived_pix/77727_kohZm1hN4NDZ6kQVznu7SGUkWk7NeJz6W9Xwa_heiqk_300x300.jpg", "300X300", "https://is0.4sqi.net/derived_pix/77727_kohZm1hN4NDZ6kQVznu7SGUkWk7NeJz6W9Xwa_heiqk_100x100.jpg", "100X100", "https://is0.4sqi.net/derived_pix/77727_kohZm1hN4NDZ6kQVznu7SGUkWk7NeJz6W9Xwa_heiqk_36x36.jpg", "36X36"],...]
        #z[picture][size]. odd index numbers are the dimensions and even are urls to the right size in descending size order
  end

  # This function gets the appropriate thumbnail for the filmstrip
  def show_thumbnail(i, width)
    if (JSON.parse(trip_activities_as_json))[i]["activityid"]
      activity_id = (JSON.parse(trip_activities_as_json))[i]["activityid"] # takes the json that we built in trips_helper and parses it so we can access the current page's activityid
      image_url = select_activity_img(TripActivity.find(activity_id), width) # find that activity id and pass it into another helper method that returns image_urls
      #logger.info "\n\n image url #{image_urls} \n"
      # if image_urls.length > 0
      #        image_urls[0][size] # access the array of image_urls.  [0] is first image [2] is the 2nd lowest quality url
      #      else
      #        return nil
      #      end
    else
      "/assets/view_from_notre_dame_flickr_large.jpg"
    end
  end

  # This function gets the name of the activity venue for the thumbnail captions
  def thumbnail_name(i)
    if (JSON.parse(trip_activities_as_json))[i]["activityid"]
      activity_id = (JSON.parse(trip_activities_as_json))[i]["activityid"]
      this_activity = TripActivity.find(activity_id)
      activity_type = this_activity.activity_type
      case 
          when activity_type == "FoodActivity" then thumb_name = this_activity.activity.restaurant_detail[:name]
          when activity_type == "TransportActivity" then thumb_name = this_activity.activity.location_detail[:name]
          # when activity_id.activity_type == "LocationActivity" then thumb_name = activity_id.activity.transport_detail[:name]
      end
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
  
  def get_trip_map_info(trip_activities_info)
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
