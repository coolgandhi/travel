class TripsController < ApplicationController
  include ApplicationHelper
  include TripsHelper
  before_filter :authorize, :only => [:new, :edit, :create, :update, :trips_admin]
  before_filter :authenticate_author_info!, :except => [:index, :show, :showpartial, :daymapinfo, :publish_up_vote]
  before_filter :allow_owner_change_only, :except => [:index, :show, :showpartial, :daymapinfo, :publish_up_vote]
  layout :resolve_layout
  # GET /trips
  # GET /trips.json 
  def index
    find_exact_match_only = false
    if (params[:restaurant] or params[:location] )
      find_exact_match_only = true
    end
    @trips, @exact_match_count, @message_with_trip_render = Trip.search(params, find_exact_match_only)
    @trips, @exact_match_count, @message_with_trip_render = get_trips_filtered_by_landmarks(params, @trips, @message_with_trip_render, @exact_match_count)
    @locations = nil
    @restaurants = nil
    @traveler_types = nil
    @trips_to_add = nil
    @conv_rendered = false
    trips_per_page_default = 3

    if (params[:trip_location_id] and params[:trip_location_id] != "" and (params[:page] == nil or params[:page] == "1" or params[:continuous] == "1"))
      # generate landmark of interest only for the initial trip search with location, not while paginating 
      @locations = LocationDetail.search(params[:trip_location_id])
      @restaurants = RestaurantDetail.search(params[:trip_location_id])
      if (params[:traveler_type_id])
        @traveler_types = TravelerType.where("traveler_type_id IN (?)", params[:traveler_type_id])
      end
    end
    
    @trips_per_page = (params[:per_page] && params[:per_page] != "")?params[:per_page].to_i : trips_per_page_default
    page  = (params[:page])? params[:page].to_i : 1
    @exact_match_count = @exact_match_count - (page - 1) * @trips_per_page
    if ( params[:continuous] == "1" and params[:page] != nil and params[:page] != "1" )
        @trips_to_add = Array.new      
        @trips_to_add = @trips[0, (params[:page].to_i - 1) * @trips_per_page]
    end
    
    @trips = @trips.paginate(:page => (params[:page] && params[:page] != "")?params[:page] : "1", :per_page => @trips_per_page)
    
    respond_to do |format|
      flash.now[:notice] = @message_with_trip_render
      format.html  # index.html.erb
      format.js # index.js.erb
      format.json { render json: @trips }
    end
  end

  # GET /trips/1
  # GET /trips/1.json
  def show
    begin
      @trip = Trip.find(params[:id], :include => [:author_info, :location], :select => "trips.*, author_infos.*, locations.*")
      @sorted_activities, @compressed_activities = sorted_trip_activities @trip
      @trip_stats = @trip.trip_stat
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = "Trip not found"
      redirect_to :controller => 'trips', :action => 'index'
      return
    end 

    respond_to do |format|
      if @trip.share_status == 1 or  (!current_author_info.blank? and @trip.author_id == current_author_info.id.to_s)
        format.html # show.html.erb
      else
        flash[:notice] = "Trip not found"
        format.html { redirect_to root_url()}         
      end
    end
  end

  # GET /trips/new
  # GET /trips/new.json
  def new
    @trip = Trip.new
    @author_info = AuthorInfo.new
    @location_val = ""
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @trip }
    end
  end

  # GET /trips/1/edit
  def edit
    begin  
      @trip = Trip.find(params[:id])
      @author_info = @trip.author_info
      @location_detail = Location.find_by_location_id(@trip.location_id)
      @location_val = @location_detail.city + "," +  @location_detail.state + "," + @location_detail.country
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = "Trip not found"
      redirect_to :controller => 'trips', :action => 'index'
      return
    end 
  end

  # POST /trips
  # POST /trips.json
  def create
    @trip = Trip.new(params[:trip])
    @trip.image_url = params[:selected_images]
    @author_info = AuthorInfo.find_by_email((params[:author_info][:email]).downcase)
    if @author_info.nil?
      @author_info = AuthorInfo.new(params[:author_info])
      @author_info.email = @author_info.email.downcase 
    else
      @author_info.author_name = (params[:author_info][:author_name] and params[:author_info][:author_name] != "") ? params[:author_info][:author_name]: @author_info.author_name;
      @author_info.about = (params[:author_info][:about] and params[:author_info][:about] != "") ? params[:author_info][:about]: @author_info.about;
      @author_info.twitter_handle = (params[:author_info][:twitter_handle] and params[:author_info][:twitter_handle] != "") ? params[:author_info][:twitter_handle]: @author_info.twitter_handle;
      @author_info.website = (params[:author_info][:website] and params[:author_info][:website] != "") ? params[:author_info][:website]: @author_info.website;
      @author_info.city = (params[:author_info][:city] and params[:author_info][:city] != "") ? params[:author_info][:city]: @author_info.city;
      @author_info.state = (params[:author_info][:state] and params[:author_info][:state] != "") ? params[:author_info][:state]: @author_info.state;
      @author_info.country = (params[:author_info][:country] and params[:author_info][:country] != "") ? params[:author_info][:country]: @author_info.country;
    end

    
    respond_to do |format|
      if @author_info.save
        @trip.author_id = @author_info.id
        if @trip.save
          format.html { redirect_to @trip, notice: 'Trip was successfully created.' }
          format.json { render json: @trip, status: :created, location: @trip }
        else
          format.html { render action: "new" }
          format.json { render json: @trip.errors, status: :unprocessable_entity }
        end
      else
        #@trip.author_id = "a"
        format.html { render :action => :new }
        format.json { render json: @author_info.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /trips/1
  # PUT /trips/1.json
  def update
    begin  
      @trip = Trip.find(params[:id])
      @author_info = AuthorInfo.find_by_email((params[:author_info][:email]).downcase)
      update_author = 0
      if @author_info.nil?
        update_author = 1
        @author_info = AuthorInfo.new(params[:author_info])
        @author_info.email = @author_info.email.downcase
      else
        if (@trip.author_id != @author_info.id.to_s)
          @trip.author_id = @author_info.id
          update_author = 2
        end
      end
      
      if (params[:selected_images] != "")
        @trip.image_url = params[:selected_images]
      end
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = "Trip not found"
      redirect_to :controller => 'trips', :action => 'index'
      return
    end 

    respond_to do |format|
      if update_author == 0 and @trip.update_attributes(params[:trip]) and @author_info.update_attributes(params[:author_info])
        format.html { redirect_to @trip, notice: 'Trip was successfully updated.' }
        format.json { head :no_content }
      elsif update_author == 1 and @author_info.save
        @trip.author_id = @author_info.id
        if @trip.update_attributes(params[:trip])
          format.html { redirect_to @trip, notice: 'Trip was successfully updated.' }
          format.json { head :no_content }        
        else
          format.html { render action: "edit" }
          format.json { render json: @trip.errors, status: :unprocessable_entity }          
        end
      elsif update_author == 2 and @trip.update_attributes(params[:trip])
        format.html { redirect_to @trip, notice: 'Trip was successfully updated.' }
        format.json { head :no_content }        
      else
        format.html { render action: "edit" }
        format.json { render json: @trip.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trips/1
  # DELETE /trips/1.json
  def destroy
    begin
      @trip = Trip.find(params[:id])
      @author_info = @trip.author_info
      @trip.trip_activities.each {|trip_activity| 
        if !trip_activity.self_trip_activity_photos.first.blank? and !trip_activity.self_trip_activity_photos.first.self_photo.blank?
          trip_activity.self_trip_activity_photos.each { |self_trip_activity_photo|
            self_trip_activity_photo.destroy }
        end
        trip_activity.activity.destroy
      }
      @trip_stat = @trip.trip_stat 
      if !@trip_stat.blank?
        @trip_stat.destroy
      end
      @trip.destroy
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = "Trip not found"
      redirect_to author_page_author_info_path(@author_info)
      return
    end 

    respond_to do |format|
      format.html { redirect_to author_page_author_info_path(@author_info), notice: 'Trip was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  def showpartial
    #logger.info "trictive #{params.inspect}"
    begin
      @trip = Trip.find(params[:id])
      @author = @trip.author_info
    
      @partial_layout = params[:layout]
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = "Trip not found"
      redirect_to :controller => 'trips', :action => 'index'
      return
    end 
    
    render :partial => "#{@partial_layout}", :layout => false
  end

  def trips_admin
    @trips = Trip.all
    
    respond_to do |format|
      format.html 
      format.json { render json: @trip_activities }
    end
  end

  def edit_individual
    @trips = Trip.find(params[:trip_ids])      
  end

  def update_individual
    @trips = Trip.update(params[:trips].keys, params[:trips].values).reject { |p| p.errors.empty? }
    if @trips.empty? 
      flash[:notice] = "Products updated"
      redirect_to trips_admin_trips_path
    else
      render :action => 'edit_individual'
    end
  end

  def daymapinfo
    begin
      @trip = Trip.find(params[:id])
      @trip_details = @trip.trip_activities.where("activity_day = ?", params[:activity_day]).first.prev_activities_sequence_number
      @current_activity = @trip_details.first.id
      #logger.info { "\n\ntripdetails...  #{@trip_details.inspect} #{@current_activity}"}
    
      @day_map_info = view_context.get_trip_map_info @trip_details, @current_activity
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = "Trip activity not found"
      redirect_to :controller => 'trips', :action => 'index'
      return
    end
    
    respond_to do |format|
      format.html # mapinfo.html.erb
      format.json { render json: @day_map_info  } 
    end
  end

  # GET /trips/publish_new
  def publish_new
    @trip = Trip.new
    @trip.share_status = 0
    @location_val = ""
    @trip_message = "Create Trip"
    @trip_publish = "publish_create"
    respond_to do |format|
      format.html # publish_new.html.erb
    end
  end

  # Post /trips/publish_create
  def publish_create
    @trip = Trip.new(params[:trip])
    @trip.share_status = 0
    @location_detail = Location.find_by_location_id(@trip.location_id)
    @update = 0
    if (params[:trip][:image_url].blank?)
      FoursquareInteraction.foursquare_client
      @venue_id = FoursquareInteraction.find_closest_venue(@location_detail.latitude, @location_detail.longitude, @location_detail.city)
      if (@venue_id != "")
        @venue_photos_com = self.get_photos(@venue_id, 4, false)
        images = @venue_photos_com.to_s.split(";")
        @trip.image_url = images.length > 0 ? images[0]: ""
      else
        @trip.image_url = ""
      end
    else
      @trip.image_url = params[:trip][:image_url]
    end
    @trip.tags = ((params[:tag1].nil? or params[:tag1] == "")? "" : params[:tag1] + ";") + 
                 ((params[:tag2].nil? or params[:tag2] == "")? "" : params[:tag2] + ";") +
                 ((params[:tag3].nil? or params[:tag3] == "")? "" : params[:tag3] + ";") 
    @trip.author_id = current_author_info.id
    @trip_message = "Create Trip"
    @trip_publish = "publish_create"
    respond_to do |format|
      if @trip.save
        @trip_stat = TripStat.new(:trip_id => @trip.id)
        @trip_stat.save # no check here if trip_stat row doesn't get created
        @trip_message = "Update Trip"
        @location_val = @location_detail.city + "," +  @location_detail.state + "," + @location_detail.country
        
        @trip_publish = publish_update_trip_url(@trip)
        format.html { redirect_to publish_edit_trip_url(@trip), notice: 'Trip was successfully updated.' }
        format.json { render json: @trip, status: :created, location: @trip }
      else
        logger.info "#{@trip.errors.inspect}"
        format.html { render :action => "publish_new" }
        format.json { render json: @trip.errors, status: :unprocessable_entity }
      end
    end
  end


  # GET /trips/1/publish_edit
  def publish_edit
    begin  
      @trip = Trip.find(params[:id])
      @trip_activity = @trip.trip_activities.new
      @location_detail = Location.find_by_location_id(@trip.location_id)
      @location_val = @location_detail.city + ", " +  @location_detail.state + ", " + @location_detail.country
      @latlong = find_location_latlong(@trip)
      @trip_message = "Update Trip"
      @trip_publish = "publish_update"
      @trip_activity_publish = "publish_trip_activity_create_trip_trip_activities"
      # @sorted_activities, @compressed_activities = sorted_trip_activities @trip
      
      split_tags = @trip.tags.blank? ? nil : @trip.tags.split(";")
      if (!split_tags.blank?)
        params[:tag1] = split_tags[0]
        params[:tag2] = split_tags[1]
        params[:tag3] = split_tags[2]
      end
      @trip_activities = @trip.trip_activities.all.sort_by {|e|
         e[:activity_sequence_number]}
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = "Trip not found"
      redirect_to :controller => 'trips', :action => 'index'
      return
    end 
  end
  
  # PUT /trips/1/publish_update
  def publish_update
    begin  
      @trip = Trip.find(params[:id])
      # @trip.image_url = (params[:image_url].blank? ) ? @trip.image_url: params[:image_url]
      @trip.tags = ((params[:tag1].nil? or params[:tag1] == "")? "" : params[:tag1] + ";") + 
                   ((params[:tag2].nil? or params[:tag2] == "")? "" : params[:tag2] + ";") +
                   ((params[:tag3].nil? or params[:tag3] == "")? "" : params[:tag3] + ";") 
      
       @location_detail = Location.find_by_location_id(@trip.location_id)
       @location_val = @location_detail.city + "," +  @location_detail.state + "," + @location_detail.country
       @trip_message = "Update Trip"
       @trip_publish = "publish_update"
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = "Trip not found"
      redirect_to :controller => 'trips', :action => 'index'
      return
    end
    respond_to do |format|
      if @trip.update_attributes(params[:trip])
        format.html { redirect_to publish_edit_trip_url(@trip), notice: 'Trip was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "publish_edit" }
        format.json { render json: @trip.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def publish_add_day
    begin
      @trip = Trip.find(params[:id])
      @status = 0
      @day = (@trip.duration.to_i + 1)
      @trip.duration = @day.to_s
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = "Trip activity not found"
      redirect_to :controller => 'trips', :action => 'index'
      return
    end

    @success_msg = ""    
    respond_to do |format|
      if @trip.save
        @success_msg = "Trip Day Added Successfully!"
        @status = 1
      end      
      flash.now[:success] = @success_msg
      format.js
      format.html { redirect_to @trip }
      format.json { head :no_content }        
    end
  end
  
  
  def publish_delete_day
     begin
       @trip = Trip.find(params[:id])
       @day = "0"
       if (params[:day])
         @day = params[:day]
         @trip_activities_day =  TripActivity.find(:all, :conditions => {:trip_id => @trip.id, :activity_day => @day})
         @trip_activities_day.each { |trip_activity|
           activity = trip_activity.activity
           activity.destroy if !activity.nil?
         }
         
         TripActivity.destroy_all(:trip_id => @trip.id, :activity_day => @day)
         @trip_activities_greater_day = TripActivity.where( 'trip_id = ? and activity_day > ?', @trip.id, @day)
         @trip_activities_greater_day.each {|trip_activity_greater_day|
           trip_activity_greater_day.activity_day = (trip_activity_greater_day.activity_day.to_i - 1).to_s
           trip_activity_greater_day.save           
         }
         @trip.duration = (@trip.duration.to_i - 1).to_s
         @trip.save
       end
     rescue ActiveRecord::RecordNotFound
       flash[:notice] = "Trip Day not found"
       redirect_to :controller => 'trips', :action => 'index'
       return
     end

     @success_msg = "Trip day deleted successfully!"    
     respond_to do |format|
       flash.now[:success] = @success_msg 
       format.js # publish_delete_day
       format.html { redirect_to @trip }
       format.json { head :no_content }        
     end
   end
   
   
  def publish_trip_partial_format
    begin
      @trip = Trip.find(params[:id])
      @trip_activities = @trip.trip_activities.all.sort_by {|e| e[:activity_sequence_number]}
  
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = "Trip activity not found"
      redirect_to :controller => 'trips', :action => 'index'
      return
    end

    respond_to do |format|
       format.js 
       format.json { head :no_content }        
    end
  end
  
  
  # GET /trips/1/publish_confirm
  def publish_confirm
    begin
      @trip = Trip.find(params[:id])
      # @trip.share_status = 1
      @location_detail = Location.find_by_location_id(@trip.location_id)
      @location_val = @location_detail.city + "," +  @location_detail.state + "," + @location_detail.country
      @latlong = find_location_latlong(@trip)
      # @trip_message = "Publish Trip"
      @trip_publish = "publish_confirm_update"
      @trip_activities = @trip.trip_activities.all.sort_by {|e|
         e[:activity_sequence_number]}

      split_tags = @trip.tags.blank? ? nil : @trip.tags.split(";")
      if (!split_tags.blank?)
        params[:tag1] = split_tags[0]
        params[:tag2] = split_tags[1]
        params[:tag3] = split_tags[2]
      end
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = "Trip activity not found"
      redirect_to :controller => 'trips', :action => 'index'
      return
    end
  end

  # PUT /trips/1/publish_update
  def publish_confirm_update
    begin  
      @trip = Trip.find(params[:id])
      @location_detail = Location.find_by_location_id(@trip.location_id)
      @location_val = @location_detail.city + "," +  @location_detail.state + "," + @location_detail.country
      @latlong = find_location_latlong(@trip)
      # @trip_message = "Publish Trip"
      @trip_publish = "publish_confirm_update"
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = "Trip not found"
      redirect_to :controller => 'trips', :action => 'index'
      return
    end
    respond_to do |format|
      if @trip.update_attributes(params[:trip])
        format.html { redirect_to @trip, notice: @trip.share_status == 0 ? 'Trip has been Unpublished' : 
        'Trip was successfully Published'  }
        format.json { head :no_content }
      else
        format.html { render action: "publish_confirm" }
        format.json { render json: @trip.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def publish_up_vote
    begin
      @status = 0
      @trip_stat = TripStat.find_by_trip_id(params[:id])
      if @trip_stat.nil?
        @trip = Trip.find(params[:id])
        @trip_stat = TripStat.new
        #@trip.trip_stat.new(:trip_id => @trip.id)
        @trip_stat.trip_id = @trip.id
        @trip_stat.useful = 1
        if @trip_stat.save # no check here if trip_stat row doesn't get created
          @status = 1
        end
      else
        @trip_stat.useful = @trip_stat.useful + 1
        if @trip_stat.save
          @status = 1
        end
      end
        
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = "Trip not found"
      redirect_to root_url
      return
    end
    
    respond_to do |format|
      format.html 
      format.js  
    end
  end
  
   
  private

  def resolve_layout
    case action_name
    when "show"
      "showtriplayout"
    when "index", "publish_new", "publish_edit", "publish_create", "publish_update", "publish_add_day", "publish_trip_partial_format", "publish_confirm", "publish_up_vote"
      "index_layout"
    else
      "application"
    end
  end

  def allow_owner_change_only
    if (params[:id])  
      @trip = Trip.find(params[:id])
      if ((!current_author_info.blank? and @trip.author_id != current_author_info.id.to_s) and !self.admin? )
        flash[:notice] = "Unauthorized Access"
        redirect_to root_url 
      end
    end
  end
  
  def use_https?
    #case params[:action]
    #when 
    #else
    #    false # Override in other controllers
    #end
    false
  end
end
