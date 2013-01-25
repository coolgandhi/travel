module ApplicationHelper

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
    @venue[:tags].each { |ven_tag|
         tag = tag + ven_tag + " "
    }
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
  
  def create_food_venue(venue_id)
    FoursquareInteraction.foursquare_client
    @venue = FoursquareInteraction.venue_info(venue_id)
    @venue_tips = FoursquareInteraction.venue_tips(venue_id)
    tag = get_tag_from_venue(@venue)
    open_hours = get_open_hours_from_venue(@venue)
    
    @activity_detail = RestaurantDetail.new 
    @activity_detail.attributes = { :restaurant_detail_id => @venue[:id], :address1 => @venue[:location][:address], :city => @venue[:location][:city], :address2 => @venue[:location][:crossStreet], :country => @venue[:location][:country], :state => @venue[:location][:state], :latitude => @venue[:location][:lat].to_s, :longitude => @venue[:location][:lng].to_s, :phone => @venue[:contact][:formattedPhone], :zip => @venue[:location][:postalCode], :name => @venue[:name], :website => @venue[:url], :category => ( @venue[:categories].first[:name] + ", " + @venue[:categories].first[:parents].first), :description => tag, :open_hours => open_hours}

    if @activity_detail.save
    else
      logger.info "error" #todo instrumentation
    end
    @activity_detail
  end
  
  
  
  def create_location_venue(venue_id)
    FoursquareInteraction.foursquare_client
    @venue = FoursquareInteraction.venue_info(venue_id)
    @venue_tips = FoursquareInteraction.venue_tips(venue_id)
    tag = get_tag_from_venue(@venue)
    open_hours = get_open_hours_from_venue(@venue)
    
    @activity_detail = LocationDetail.new
    @activity_detail.attributes = { :location_detail_id => @venue[:id], :address1 => @venue[:location][:address], :city => @venue[:location][:city], :address2 => @venue[:location][:crossStreet], :country => @venue[:location][:country], :state => @venue[:location][:state], :latitude => @venue[:location][:lat].to_s, :longitude => @venue[:location][:lng].to_s, :phone => @venue[:contact][:formattedPhone], :zip => @venue[:location][:postalCode], :name => @venue[:name], :website => @venue[:url], :category => ( @venue[:categories].first[:name] + ", " + @venue[:categories].first[:parents].first), :description => tag, :open_hours => open_hours}
    if @activity_detail.save
    else
      logger.info "error" #todo instrumentation
    end
    @activity_detail
  end
end
