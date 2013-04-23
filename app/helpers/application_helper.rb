module ApplicationHelper

  
  def get_photos venue_id, tot
    FoursquareInteraction.foursquare_client
    venue_photos = FoursquareInteraction.venue_photos(venue_id, tot)
    venue_photos_com = get_photos_from_venue_photos(venue_photos, tot)
    #logger.info "#{@venue_photos_com.inspect}"
     
    venue_photos_com = get_photos_from_venue_photos_with_json(venue_photos_com, true)
    
    venue_photos_first = get_photos_from_venue_photos_first_resolution(venue_photos, tot)
    venue_photos_first = get_photos_from_venue_photos_with_json(venue_photos_first, false)
    return venue_photos_first, venue_photos_com
  end
  
  def empty_string_if_value_nil(value)
    ret_value = (value.nil?) ? "" : value
    ret_value
  end
  
  def get_tag_from_venue(venue)
    tag = ""
    if venue[:description] 
      tag = tag + venue[:description] + " "
    elsif venue.has_key?(:page)
      begin
        temp_copy = venue[:page][:pageInfo][:description]
        tag = tag + temp_copy + " "
      rescue
        # do nothing
      end
    end
    # @venue[:tags].each { |ven_tag|
    #      tag = tag + ven_tag + " "
    # }
    tag
  end
  
  def get_open_hours_from_venue(venue)
    open_hours = ""
    if venue[:hours]
      venue[:hours][:timeframes].each { |timeframes_tag|
        open_hours = open_hours + timeframes_tag[:days] + " "
        timeframes_tag[:open].each { |open_tag|
          open_hours = open_hours + open_tag[:renderedTime] + " "   
        }
        open_hours = open_hours + ", "
      }
    end
    open_hours
  end
  
  def get_photos_from_venue_photos(photos, limit = 5)
    photos_ret = ""
    count = 0;
    if photos[:items]
      photos[:items].each {|photo|
        if photo[:sizes][:items]
          photos_ordered = (photo[:sizes])[:items].sort_by {|e| -e[:width]}
          photos_ordered.each {|photo_element|
            photos_ret = photos_ret + photo_element[:url] + "," + photo_element[:width].to_s + "X" + photo_element[:height].to_s + ","
          }
          photos_ret.chomp!(',')
          photos_ret = photos_ret + ";"
          count = count + 1
          if count > limit 
            break
          end
        end
      }
    end
    photos_ret
  end
    
  def get_photos_from_venue_photos_first_resolution(photos, limit=5)
    photos_ret = ""
    count = 0;
    if photos[:items]
      photos[:items].each {|photo|
        if photo[:sizes][:items]
          photos_ret = photos_ret + photo[:sizes][:items].first[:url] + ","
        end
        count = count + 1
        if count > limit 
          break
        end
      }
      photos_ret.chomp!(',')   
    end
    photos_ret
  end
  
  def get_photos_from_venue_photos_with_json(photos, use_semi_colon)
    photos_ret = ""
    if photos != ""
      if use_semi_colon
        photos_arr = photos.split(/;/)
      else
        photos_arr = photos.split(/,/)
      end
      photos_ret = photos_arr.map {|x| {"img"=>x}}
    end
    photos_ret
  end
  
  def get_categories_from_venue(full_venue_structure)
    category = ""
    if full_venue_structure[:categories] != nil and  full_venue_structure[:categories].first
      category_name = empty_string_if_value_nil(full_venue_structure[:categories].first[:name])
      category_parents = empty_string_if_value_nil(full_venue_structure[:categories].first[:parents].first)
      
      if category_name != ""
        category = category_name 
      end
      
      if category_parents != ""
        if category != ""
          category =  category + ", "
        end
        category = category + category_parents
      end
    end
    category
  end
  
  def create_food_venue(venue_id, location_id, update=0, venue=0)
    FoursquareInteraction.foursquare_client
    if venue.blank?
      @venue, error = FoursquareInteraction.venue_info(venue_id)
      if error != ""
        Rails.logger.info " errors #{error}"
        return nil
      end
    else
      @venue = venue
    end
    #options = {:sort => "recent", :limit => 25}
    @venue_tips = FoursquareInteraction.venue_tips(venue_id)     
    @venue_photos = FoursquareInteraction.venue_photos(venue_id)
    tag = get_tag_from_venue(@venue)
    photos = get_photos_from_venue_photos(@venue_photos)
    open_hours = get_open_hours_from_venue(@venue)
    
    @activity_detail = update == 0 ? RestaurantDetail.new : RestaurantDetail.find_by_restaurant_detail_id(@venue[:id])
    category = get_categories_from_venue(@venue)
    
    @activity_detail.attributes = { 
      :restaurant_detail_id => @venue[:id], 
      :address1 => empty_string_if_value_nil(@venue[:location][:address]), 
      :city => empty_string_if_value_nil(@venue[:location][:city]), 
      :address2 => empty_string_if_value_nil(@venue[:location][:crossStreet]), 
      :country => empty_string_if_value_nil(@venue[:location][:country]), 
      :state => empty_string_if_value_nil(@venue[:location][:state]), 
      :latitude => empty_string_if_value_nil(@venue[:location][:lat].to_s), 
      :longitude => empty_string_if_value_nil(@venue[:location][:lng].to_s), 
      :phone => empty_string_if_value_nil(@venue[:contact][:formattedPhone]), 
      :zip => empty_string_if_value_nil(@venue[:location][:postalCode]), 
      :name => empty_string_if_value_nil(@venue[:name]), 
      :website => empty_string_if_value_nil(@venue[:url]), 
      :category => category, 
      :description => tag, 
      :open_hours => open_hours, 
      :image_urls => photos, 
      :location_id => location_id,
      :rating => empty_string_if_value_nil(@venue[:rating]),
      :twitter => empty_string_if_value_nil(@venue[:contact][:twitter]),
      :source => "foursquare"
    }


    if @activity_detail.save
      if  update == 1
        @activity_detail.restaurant_comments.delete_all
      end
      
      if @venue_tips[:count] 
        count = @venue_tips[:count].to_i
        iteration = 0
        @venue_tips[:items].each { |venue_tip|
          venue_comment = RestaurantComment.new
          name = empty_string_if_value_nil(venue_tip[:user][:firstName]) + " " + empty_string_if_value_nil(venue_tip[:user][:lastName])
          venue_comment.attributes = {
            :created_time => Time.at(venue_tip[:createdAt]), 
            :follow_post_id => "", 
            :log => empty_string_if_value_nil(venue_tip[:text]), 
            :name => name, 
            :photo => "", 
            :restaurant_detail_id => @venue[:id], 
            :source => "foursquare", 
            :summary => empty_string_if_value_nil(venue_tip[:likes][:summary]), 
            :url => empty_string_if_value_nil(venue_tip[:canonicalUrl])
          }
          
          if venue_comment.save
          else
            Rails.logger.info "error #{venue_tip.errors} \n" #todo instrumentation
            raise "Venue tips savings error #{venue_tip.errors} "
          end          
          iteration = iteration + 1
          break if iteration > 25 
        }
      end 
    else
      Rails.logger.info "error #{@activity_detail.errors} \n" #todo instrumentation
      raise "Venue savings error #{@activity_detail.errors} "
    end
    @activity_detail
  end
  
  
  
  def create_location_venue(venue_id, location_id, update=0, venue=0)
    FoursquareInteraction.foursquare_client
    if venue.blank?
      @venue, error = FoursquareInteraction.venue_info(venue_id)
      if error != ""
        return nil
      end
    else
      @venue = venue
    end
    
    @venue_tips = FoursquareInteraction.venue_tips(venue_id)
    @venue_photos = FoursquareInteraction.venue_photos(venue_id)
    tag = get_tag_from_venue(@venue)
    open_hours = get_open_hours_from_venue(@venue)
    photos = get_photos_from_venue_photos(@venue_photos)
    
    @activity_detail = update == 0 ? LocationDetail.new : LocationDetail.find_by_location_detail_id(@venue[:id])
    
    category = get_categories_from_venue(@venue)
        
    @activity_detail.attributes = { 
      :location_detail_id => @venue[:id], 
      :address1 => empty_string_if_value_nil(@venue[:location][:address]), 
      :city => empty_string_if_value_nil(@venue[:location][:city]), 
      :address2 => empty_string_if_value_nil(@venue[:location][:crossStreet]), 
      :country => empty_string_if_value_nil(@venue[:location][:country]), 
      :state => empty_string_if_value_nil(@venue[:location][:state]), 
      :latitude => empty_string_if_value_nil(@venue[:location][:lat].to_s), 
      :longitude => empty_string_if_value_nil(@venue[:location][:lng].to_s), 
      :phone => empty_string_if_value_nil(@venue[:contact][:formattedPhone]), 
      :zip => empty_string_if_value_nil(@venue[:location][:postalCode]), 
      :name => empty_string_if_value_nil(@venue[:name]), 
      :website => empty_string_if_value_nil(@venue[:url]), 
      :category => category, 
      :description => tag, 
      :open_hours => open_hours, 
      :image_urls => photos, 
      :location_id => location_id,
      :rating => empty_string_if_value_nil(@venue[:rating]),
      :twitter => empty_string_if_value_nil(@venue[:contact][:twitter]),
      :source => "foursquare"
    }
    
    if @activity_detail.save
      if update == 1
        @activity_detail.location_comments.delete_all
      end
      
      if @venue_tips[:count] 
        count = @venue_tips[:count].to_i
        iteration = 0
        @venue_tips[:items].each { |venue_tip|
          venue_comment = LocationComment.new
          name = empty_string_if_value_nil(venue_tip[:user][:firstName]) + " " + empty_string_if_value_nil(venue_tip[:user][:lastName])
          venue_comment.attributes = {
            :created_time => Time.at(venue_tip[:createdAt]), 
            :follow_post_id => "", 
            :log => empty_string_if_value_nil(venue_tip[:text]), 
            :name => name, 
            :photo => "", 
            :location_detail_id => @venue[:id], 
            :source => "foursquare", 
            :summary => empty_string_if_value_nil(venue_tip[:likes][:summary]), 
            :url => empty_string_if_value_nil(venue_tip[:canonicalUrl])
          }
          
          if venue_comment.save
          else
            Rails.logger.info "error #{venue_tip.errors} \n" 
            raise "Venue tips savings error #{venue_tip.errors} "
          end          
          iteration = iteration + 1
          break if iteration > 25 
        }
      end
    else
      Rails.logger.info "error #{@activity_detail.errors.inspect} \n" 
      raise "Venue savings error #{@activity_detail.errors} "
    end
    @activity_detail
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
  
  # index details which image to pick if multiple images
  def select_image_given_image_urls(image_urls, width, index = 0)
    if image_urls.nil? or image_urls == ""
      return "/assets/Image_Missing.png"
    end
    
    y = image_urls.to_s.split(";")
    
    if index < y.length
      y = y[index]
    elsif y.length > 0
      y = y[0]
    else
      return ""
    end
    
    z = y.split(",")
    image = select_closest_image(z, width)
  end
  
  # for pill nav bar to set active or disabled
  def nav_link(link_text, link_path)
    class_name = current_page?(link_path) ? 'active' : ''

    content_tag(:li, :class => class_name) do
      link_to link_text, link_path
    end
  end

  #compile map info
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

  def get_closest_category(categories)
    ret_category = "LocationActivity"
    categories.each {|category|
      if category[:parents]
        category[:parents].each { |category_parent|
          if category_parent.downcase.include? "food"
            ret_category = "FoodActivity"
            break
          end
          if category_parent.downcase.include? "cafeteria"
            ret_category = "FoodActivity"
            break
          end
        }
      end
      
      if category[:name].downcase.include? "food"
        ret_category = "FoodActivity"
        break      
      end
      if category[:name].downcase.include? "cafeteria"
        ret_category = "FoodActivity"
        break
      end
      
      case category[:id]
        when "4bf58dd8d48988d1ef931735", "4bf58dd8d48988d119951735", "4bf58dd8d48988d186941735", "50aa9e744b90af0d42d5de0e", "4bf58dd8d48988d118951735", "4bf58dd8d48988d1f5941735", "4bf58dd8d48988d120951735", "4bf58dd8d48988d10e951735", "4bf58dd8d48988d1fa941735", "4bf58dd8d48988d11e951735", "4bf58dd8d48988d11d951735", "4bf58dd8d48988d1f9941735", "4bf58dd8d48988d128941735", "4d4b7105d754a06374d81259", "503288ae91d4c4b30a586d67", "4bf58dd8d48988d1c8941735", "4bf58dd8d48988d14e941735", "4bf58dd8d48988d152941735", "4bf58dd8d48988d107941735", "4bf58dd8d48988d142941735", "4bf58dd8d48988d169941735", "4bf58dd8d48988d1df931735", "4bf58dd8d48988d179941735", "4bf58dd8d48988d16a941735", "4bf58dd8d48988d16b941735", "4bf58dd8d48988d143941735", "50327c8591d4c4b30a586d5d", "4bf58dd8d48988d16c941735", "4bf58dd8d48988d153941735", "4bf58dd8d48988d16d941735", "4bf58dd8d48988d17a941735", "4bf58dd8d48988d144941735", "4bf58dd8d48988d145941735", "4bf58dd8d48988d1e0931735", "4bf58dd8d48988d154941735", "4bf58dd8d48988d1bc941735", "4bf58dd8d48988d146941735", "4bf58dd8d48988d1d0941735", "4bf58dd8d48988d1f5931735", "4bf58dd8d48988d147941735", "4e0e22f5a56208c4ea9a85a0", "4bf58dd8d48988d148941735", "4bf58dd8d48988d108941735", "4bf58dd8d48988d109941735", "4bf58dd8d48988d10a941735", "4bf58dd8d48988d10b941735", "4bf58dd8d48988d16e941735", "4eb1bd1c3b7b55596b4a748f", "4edd64a0c7ddd24ca188df1a", "4bf58dd8d48988d1cb941735", "4bf58dd8d48988d10c941735", "4d4ae6fc7a7b7dea34424761", "4bf58dd8d48988d155941735", "4bf58dd8d48988d10d941735", "4c2cd86ed066bed06c3c5209", "4bf58dd8d48988d10e941735", "4bf58dd8d48988d16f941735", "4bf58dd8d48988d1c9941735", "4bf58dd8d48988d10f941735", "4deefc054765f83613cdba6f", "4bf58dd8d48988d110941735", "4bf58dd8d48988d111941735", "4bf58dd8d48988d112941735", "4bf58dd8d48988d113941735", "4bf58dd8d48988d1be941735", "4bf58dd8d48988d1bf941735", "4bf58dd8d48988d156941735", "4bf58dd8d48988d1c0941735", "4bf58dd8d48988d1c1941735", "4bf58dd8d48988d115941735", "4bf58dd8d48988d1c2941735", "4eb1d5724b900d56c88a45fe", "4bf58dd8d48988d1c3941735", "4bf58dd8d48988d157941735", "4eb1bfa43b7b52c0e1adc2e8", "4bf58dd8d48988d1ca941735", "4def73e84765ae376e57713a", "4bf58dd8d48988d1d1941735", "4bf58dd8d48988d1c4941735", "4bf58dd8d48988d1bd941735", "4bf58dd8d48988d1c5941735", "4bf58dd8d48988d1c6941735", "4bf58dd8d48988d1ce941735", "4bf58dd8d48988d1c7941735", "4bf58dd8d48988d1dd931735", "4bf58dd8d48988d1cd941735", "4bf58dd8d48988d14f941735", "4bf58dd8d48988d150941735", "4bf58dd8d48988d1cc941735", "4bf58dd8d48988d1d2941735", "4bf58dd8d48988d158941735", "4bf58dd8d48988d151941735", "4bf58dd8d48988d1db931735", "4bf58dd8d48988d1dc931735", "4bf58dd8d48988d149941735", "4f04af1f2fb6e1c99f3db0bb", "4bf58dd8d48988d1d3941735", "4bf58dd8d48988d14a941735", "4bf58dd8d48988d14b941735", "4bf58dd8d48988d14c941735", "512e7cae91d4cbb4e5efe0af"
        ret_category = "FoodActivity"
        break 
      end
    }
    
    ret_category
  end
  
  
  def find_location_latlong trip
    location_detail = Location.find_by_location_id(trip.location_id)
    if (location_detail)
      latlong = location_detail.latitude + "," + location_detail.longitude
    else
      latlong = "37.77493,-122.41942"  # use SF by default
    end
    latlong
  end
end
