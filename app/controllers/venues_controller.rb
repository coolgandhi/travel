class VenuesController < ApplicationController
  include ApplicationHelper
  def pick
    tot = 10
    if params[:total]
      begin
        tot = Integer(params[:total]) 
      rescue ArgumentError
        tot = 10
      end
    end
    FoursquareInteraction.foursquare_client
    @venue_suggestions = FoursquareInteraction.suggest_venues params[:latlong], params[:ven], tot.to_s
#    @venue_suggestions = FoursquareInteraction.foursquare_client.suggest_venues params[:latlong], params[:ven], tot.to_s
    respond_to do |format|
      format.html # pick.html.erb
      format.json { render json: @venue_suggestions }
    end
  end
  
  def get_info
  end
  
  def get_venue_photos
    tot = 20
    @venue_photos_first = nil
    @venue_photos_com = nil
    if params[:total]
      begin
        tot = Integer(params[:total]) 
      rescue ArgumentError
        tot = 20
      end
    end
    
    if params[:venueid]
      @venue_photos_first, @venue_photos_com = get_photos(params[:venueid], tot)
    elsif params[:latitude] and params[:longitude] and params[:place]
      FoursquareInteraction.foursquare_client
      @venue_id = FoursquareInteraction.find_closest_venue(params[:latitude], params[:longitude], params[:place] )
      if (@venue_id != "")
        @venue_photos_first, @venue_photos_com = get_photos(@venue_id, tot)
      end
    end
    
    respond_to do |format|
      format.json { render json: { 
                                  :venue_photos => @venue_photos_first, 
                                  :venue_photos_com => @venue_photos_com                                                     
                                  }}
    end
  end


  def get_venue_details
    @venue_details = Hash.new
    if params[:venueid]
      FoursquareInteraction.foursquare_client
      @venue, error = FoursquareInteraction.venue_info(params[:venueid])
      @venue_details[:venue_id] = @venue[:id]
      @venue_details[:canonicalUrl] = empty_string_if_value_nil(@venue[:canonicalUrl])
      @venue_details[:address1] = empty_string_if_value_nil(@venue[:location][:address])
      @venue_details[:city] = empty_string_if_value_nil(@venue[:location][:city]) 
      @venue_details[:address2] = empty_string_if_value_nil(@venue[:location][:crossStreet]) 
      @venue_details[:country] = empty_string_if_value_nil(@venue[:location][:country]) 
      @venue_details[:state] = empty_string_if_value_nil(@venue[:location][:state]) 
      @venue_details[:phone] = empty_string_if_value_nil(@venue[:contact][:formattedPhone]) 
      @venue_details[:zip] = empty_string_if_value_nil(@venue[:location][:postalCode])
      @venue_details[:name] = empty_string_if_value_nil(@venue[:name]) 
      @venue_details[:website] = empty_string_if_value_nil(@venue[:url]) 
      @venue_details[:category_name] = empty_string_if_value_nil(@venue[:categories].first[:name]) 
      @venue_details[:category_parent] = empty_string_if_value_nil(@venue[:categories].first[:parents].first) 
      @venue_details[:rating] = empty_string_if_value_nil(@venue[:rating])
      @venue_details[:twitter] = empty_string_if_value_nil(@venue[:contact][:twitter])
      @venue_details[:source] = "foursquare"      
      @venue_details[:category] = get_closest_category(@venue[:categories])
    end
    
    respond_to do |format|
      format.json { render json: { 
                                  :venue_details =>  @venue_details 
                                  }}
    end
  end
  
  private
  
  def use_https?
    false # Override in other controllers
  end
end