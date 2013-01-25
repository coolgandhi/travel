class VenuesController < ApplicationController
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
end
