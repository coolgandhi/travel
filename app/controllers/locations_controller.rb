class LocationsController < ApplicationController
  def pick
    nearest_match = params[:near]
    @location_matches = nil
    begin 
#      @location_matches = Location.find_all_by_city(:conditions => ['Location.city LIKE ?', nearest_match])
      
      tot = 5
      if params[:total]
        begin
          tot = Integer(params[:total]) 
        rescue ArgumentError
          tot = 5
        end
      end
      
      nearest_match = "%" << nearest_match << "%"
      @location_matches = Location.limit(tot).where (['locations.city LIKE ?', nearest_match])
    rescue ActiveRecord::RecordNotFound
       logger.info "food activity entry not found"
    end
    respond_to do |format|
      format.html # pick.html.erb
      format.json { render json: @location_matches }
    end
  end
  
  private
  
  def use_https?
    false # Override in other controllers
  end
end
