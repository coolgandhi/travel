module ApplicationHelper

  
  def get_photos venue_id, tot, ret_json=true
    FoursquareInteraction.foursquare_client
    venue_photos = FoursquareInteraction.venue_photos(venue_id, tot)
    venue_photos_com = get_photos_from_venue_photos(venue_photos, tot)
    #logger.info "#{@venue_photos_com.inspect}"
    
    if ret_json == true 
      venue_photos_com = get_photos_from_venue_photos_with_json(venue_photos_com, true)
    
      venue_photos_first = get_photos_from_venue_photos_first_resolution(venue_photos, tot)
      venue_photos_first = get_photos_from_venue_photos_with_json(venue_photos_first, false)

      venue_photos_100 = get_photos_from_venue_photos_100_resolution(venue_photos, tot)
      venue_photos_100 = get_photos_from_venue_photos_with_json(venue_photos_100, false)
      return venue_photos_first, venue_photos_com, venue_photos_100
    else
      return venue_photos_com
    end
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

  def get_photos_from_venue_photos_100_resolution(photos, limit=5)
    photos_ret = ""
    count = 0;
    if photos[:items]
      photos[:items].each {|photo|
        if photo[:sizes][:items]
          photos_ret = photos_ret + photo[:sizes][:items][-3][:url] + ","
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
      if @venue.blank?
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
  
    @restaurant_detail = RestaurantDetail.find_by_restaurant_detail_id(@venue[:id])
    create_new = @restaurant_detail.blank? ? 1 : 0
    @activity_detail = (update == 0 and @restaurant_detail.blank?) ? RestaurantDetail.new : @restaurant_detail
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
      :canonical_url => empty_string_if_value_nil(@venue[:canonicalUrl]),
      :source => "foursquare"
    }


    if create_new == 1 or update == 1
      if @activity_detail.save
        if update == 1
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
    end
    @activity_detail
  end
  
  
  
  def create_location_venue(venue_id, location_id, update=0, venue=0)
    FoursquareInteraction.foursquare_client
    if venue.blank?
      @venue, error = FoursquareInteraction.venue_info(venue_id)
      if @venue.blank?
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
    
    
    @location_detail = LocationDetail.find_by_location_detail_id(@venue[:id])
    create_new = @location_detail.blank? ? 1 : 0
    
    @activity_detail = (update == 0 and @location_detail.blank?) ? LocationDetail.new : @location_detail
        
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
      :canonical_url => empty_string_if_value_nil(@venue[:canonicalUrl]),
      :source => "foursquare"
    }
    
    if create_new == 1 or update == 1
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
    if !categories.blank?
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
    end  
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

  # flash_display for ajax / jquery
  def flash_display
    response = ""
    flash.each do |name, msg|
      case name 
        when :notice then "info"
        when :error then "error"
        when :success then "success"
        when :alert then "warning"
      end
      response = response + "<div class='alert alert-#{name}'><a class='close' data-dismiss='alert'>&#215;</a>" + content_tag(:div, msg, :id => "flash_#{name}") + '</div>'
    end
    flash.discard
    response
  end

  # helper method to add the http in front of a user submitted url. need this or rails will try to prepend the domain in front of url
  def url_with_protocol(url)
    /^http/.match(url) ? url : "http://#{url}"
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

  #helper method to return user uploaded url or foursquare image url
  def upload_or_foursquare_image_url_picker (object, self_image_size=:thumb, foursquare_image_width=250, foursquare_image_index=0)
    case object.class.name
      when 'Trip'
        if !object.self_image.blank?
          use_this_url = object.self_image_url(self_image_size)
          which_url_msg = "Image Uploaded by User"
        elsif !object.self_image_tmp.blank?
          use_this_url = "/assets/temp-img-holder.png"
          which_url_msg = "We're processing your image"        
        elsif !object.image_url.blank?
          #def select_image_given_image_urls(image_urls, width, index = 0)
          use_this_url = select_image_given_image_urls(object.image_url, foursquare_image_width, foursquare_image_index)
          which_url_msg = "Image Selected from Foursquare"
        else
          use_this_url = "/assets/no-img-holder.png"
          which_url_msg = "Upload image or Choose from Foursquare"
        end
      when 'TripActivity'
        if !object.self_trip_activity_photos.first.blank? and !object.self_trip_activity_photos.first.self_photo.blank?
          use_this_url = self_image_size == :original ? object.self_trip_activity_photos.first.self_photo : object.self_trip_activity_photos.first.self_photo_url(self_image_size)
          which_url_msg = "Image Uploaded by User"
        elsif !object.activity.blank? and !object.activity.image_urls.blank?
          use_this_url = select_image_given_image_urls(object.activity.image_urls, foursquare_image_width, foursquare_image_index)
          which_url_msg = "Image Selected from Foursquare"
        elsif !object.self_trip_activity_photos.first.blank? and !object.self_trip_activity_photos.first.self_photo_tmp.blank?
          use_this_url = "/assets/temp-img-holder.png" 
          which_url_msg = "We're processing your image"
        else
          if !object.activity.blank?
            url_from_details = which_detail_type(object, 'image_urls')
            use_this_url = !url_from_details.blank? ? select_image_given_image_urls(url_from_details, foursquare_image_width, foursquare_image_index): "/assets/no-img-holder.png"
            which_url_msg = "Please Select an Image"
          else 
            use_this_url = "/assets/no-img-holder.png"
            which_url_msg = "Upload image or Choose from Foursquare"
          end
        end
    end
      return use_this_url, which_url_msg 
  end

  def author_level(author_x)
    author_trip_stats = author_x.trip_stats
    agg_author_usefuls = 0
    unless author_trip_stats.blank?
      author_trip_stats.each { |trip|
        agg_author_usefuls = agg_author_usefuls + trip.useful            
      }
    end
    # case agg_author_usefuls
    if ( agg_author_usefuls <= 25 )
      author_level = "Rookie"
      author_level_class = "level_1_badge"
      min_useful = 0
      next_level = 26 - agg_author_usefuls
      tooltip_msg = "#{author_level} becomes an Explorer after getting #{next_level} more useful votes on their trips. Click useful to help this #{author_level} get there."
    elsif ( (agg_author_usefuls >= 26) and (agg_author_usefuls <= 100) )
      author_level = "Explorer"
      author_level_class = "level_2_badge"
      min_useful = 26
      next_level = 101 - agg_author_usefuls
      tooltip_msg = "#{author_level} will become a Captain after getting #{next_level} more useful votes on their trips. Click useful to help this #{author_level} get there."
    elsif ( (agg_author_usefuls >= 101) and (agg_author_usefuls <= 500) )
      author_level = "Captain"
      min_useful = 101
      next_level = 501 - agg_author_usefuls
      author_level_class = "level_3_badge"
      tooltip_msg = "#{author_level} becomes a Superstar after getting #{next_level} more useful votes on their trips. Click useful to help this #{author_level} get there."
    elsif ( (agg_author_usefuls >= 501) and (agg_author_usefuls <= 1000) )
      author_level = "Superstar"
      author_level_class = "level_4_badge"
      min_useful = 501
      next_level = 1001 - agg_author_usefuls
      tooltip_msg = "#{author_level} has #{agg_author_usefuls} useful votes."
    # elsif ( agg_author_usefuls > 1001 )
    #   author_level = "Secret Status"
    #   author_level_class = "level_5_badge"
    #   min_useful = 1001
    #   next_level = "a lot more"
    #   tooltip_msg = "#{author_level} has #{agg_author_usefuls} useful votes."
    else
      author_level = "Rookie"
      author_level_class = "level_1_badge"
      min_useful = 0
      next_level = 26 - agg_author_usefuls
      tooltip_msg = "#{author_level} becomes an Explorer after getting #{next_level} more useful votes on their trips. Click useful to help this #{author_level} get there."
    end
    return author_level, author_level_class, min_useful, next_level, tooltip_msg
  end

end
