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
  
  def get_venue_info
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
      FoursquareInteraction.foursquare_client
      @venue_photos = FoursquareInteraction.venue_photos(params[:venueid], tot)
      @venue_photos_com = get_photos_from_venue_photos(@venue_photos, tot)
       logger.info "#{@venue_photos_com.inspect}"
       
      @venue_photos_com = get_photos_from_venue_photos_with_json(@venue_photos_com, true)
      
      @venue_photos_first = get_photos_from_venue_photos_first_resolution(@venue_photos, tot)
      @venue_photos_first = get_photos_from_venue_photos_with_json(@venue_photos_first, false)
    end
    
    respond_to do |format|
      format.json { render json: { 
                                  :venue_photos => @venue_photos_first, 
                                  :venue_photos_com => @venue_photos_com                                                     
                                  }}
    end
  end
end