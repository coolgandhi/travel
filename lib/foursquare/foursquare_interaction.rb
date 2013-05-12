class FoursquareInteraction
  include ActiveSupport::Rescuable
  @@client = nil
  def self.foursquare_client
    @@client ||= Foursquare2::Client.new(:client_id => CONFIG[:FOURSQUARE_CLIENT_ID], :client_secret => CONFIG[:FOURSQUARE_CLIENT_SECRET])
    @@client
  end
  
  def self.suggest_venues latlong, term, total
    begin
      term = term.strip
      suggestions = ""
      if term.length > 2   
        get_suggestions = @@client.suggest_completion_venues(options = {:ll => latlong, :query => term, :limit => total})
        suggestions = get_suggestions.minivenues.map {|x| {"label"=>x.name,"value"=>x.id, "address"=>x.location.address, "city"=>x.location.city, "state"=>x.location.state, "lat"=>x.location.lat, "lng"=>x.location.lng}}
      end
    rescue Exception => exc
      suggestions = nil
      Rails.logger.info "Exception #{exc}! \nError Exception Message #{exc.message}  \nException Inspect #{exc.inspect}\n"
      ExceptionNotifier::Notifier.exception_notification($request.env, exc, :data => {:message => "chalo.io error: please check"}).deliver 
      error = exc.inspect
    end  
    
    suggestions
  end

  def self.venue_info venue_id
    begin
      error = nil
      venue = @@client.venue venue_id
   rescue Exception => exc
      Rails.logger.info "Exception #{exc}! \nError Exception Message #{exc.message}  \nException Inspect #{exc.inspect}\n"
      ExceptionNotifier::Notifier.exception_notification($request.env, exc, :data => {:message => "chalo.io error: please check"}).deliver 
      error = exc.inspect
    end
    
    return venue, error
  end
  
  def self.venue_photos(venue_id, count = 20)
    get_photos = @@client.venue_photos(venue_id, options = {:group => 'venue', :limit => count.to_s()})
    #logger.info " venue info ... #{get_photos}"
    get_photos
    
  end
  
  
  def self.venue_tips venue_id
    tips = @@client.venue_tips(venue_id, options = {:sort => "recent", :limit => "25"})
    tips
  end

  def self.find_closest_venue(latitude, longitude, place)
    get_places = @@client.search_venues(options = {:ll => latitude + "," + longitude, :near => place, :categoryId => "50aa9e094b90af0d42d5de0d", :radius => 5000, :limit => 10})
    # find closest category:city, within raidus of 5 kms limited to 3 results
    id = ""
    if get_places[:groups] and (get_places[:groups]).first[:items].length > 0
      (get_places[:groups]).first[:items].each {|get_place|
        # normalizing the foursquare representation e.g. San José to San Jose
        if get_place[:name].mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n,'').to_s.downcase.include?place.downcase
          id = get_place[:id]
          break
        end
      } 
      if id == "" # add a best case closest city for now (first one on the list)
        (get_places[:groups]).first[:items].each {|get_place|
          id = get_place[:id]
          break
        }
      end
    else
      Rails.logger.info "Couldn't search for venues for latitude:#{latitude}, longitude:#{longitude}, place:#{place}" 
    end
    if (id == "")
      Rails.logger.info " Couldn't find venue id"       
    end
    id
  end
end