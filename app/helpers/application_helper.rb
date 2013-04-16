module ApplicationHelper

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
  
  def create_food_venue(venue_id, location_id, update=0)
    FoursquareInteraction.foursquare_client
    @venue, error = FoursquareInteraction.venue_info(venue_id)
    if error != ""
      Rails.logger.info " errors #{error}"
      return nil
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
  
  
  
  def create_location_venue(venue_id, location_id, update=0)
    FoursquareInteraction.foursquare_client
    @venue, error = FoursquareInteraction.venue_info(venue_id)
    if error != ""
      return nil
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
      Rails.logger.info "error #{@activity_detail.errors} \n" 
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


end
