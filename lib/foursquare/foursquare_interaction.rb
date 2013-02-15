class FoursquareInteraction
  @@client = nil
  def self.foursquare_client
    @@client ||= Foursquare2::Client.new(:client_id => CONFIG[:FOURSQUARE_CLIENT_ID], :client_secret => CONFIG[:FOURSQUARE_CLIENT_SECRET])
    @@client
  end
  
  def self.suggest_venues latlong, term, total
   get_suggestions = @@client.suggest_completion_venues(options = {:ll => latlong, :query => term, :limit => total})
  #    get_suggestions = @@client.search_venues(options = {:ll => "37.77,-122.42", :query => "star", :limit => "10"})
  # Rails.logger.info "\n\n #{get_suggestions.inspect}"
   suggestions = get_suggestions.minivenues.map {|x| {"label"=>x.name,"value"=>x.id, "address"=>x.location.address, "city"=>x.location.city, "state"=>x.location.state, "lat"=>x.location.lat, "lng"=>x.location.lng}}
  end

  def self.venue_info venue_id
     venue = @@client.venue venue_id
     venue
  end
  
  def self.venue_photos(venue_id, count = 20)
    get_photos = @@client.venue_photos(venue_id, options = {:group => 'venue', :limit => count.to_s()})
    #logger.info " venue info ... #{get_photos}"
    get_photos
    
   # get_photos = @@client.venue_photos(venue_id, options = {:group => 'venue', :limit => '5'})
   # photos = get_photos.items.map {|x| {"image_url"=>x.url}}
   # photos
  end
  
  
  def self.venue_tips venue_id
    tips = @@client.venue_tips(venue_id, options = {:limit => '5'})
    tips
  end
end