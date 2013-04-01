class TripActivitiesController < ApplicationController
  include ApplicationHelper
  include TripActivitiesHelper
  before_filter :load_trip
  before_filter :authorize, :except => [:mapinfo, :showpartial]
  # GET /trip_activities
  # GET /trip_activities.json
  def index
    @trip_activities = @trip.trip_activities.all.sort_by {|e| e[:activity_sequence_number]}
    # if ["move_lower", "move_higher", "move_to_top", "move_to_bottom"].include?(params[:method]) and params[:trip_activity_id] =~ /^\d+$/
    #   TripActivity.find(params[:trip_activity_id]).send(params[:method])
    # end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @trip_activities }
    end
  end

  # GET /trip_activities/1
  # GET /trip_activities/1.json
  def show
    begin
      @trip_activity = @trip.trip_activities.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = "Trip activity not found"
      redirect_to :controller => 'trips', :action => 'index'
      return
    end
    
    respond_to do |format| require 'trip_activities_controller'
      format.html # show.html.erb
      format.json { render json: @trip_activity }
    end
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
  
  # GET /trip_activities/new
  # GET /trip_activities/new.json
  def new
    @activity = nil
    @trip_activity = @trip.trip_activities.new
    @trip_activity.trip_id = params[:trip_id]
    @latlong = find_location_latlong @trip
    @trip_activities = @trip.trip_activities.all.sort_by {|e| e[:activity_sequence_number]}

    #if we have less than one activity, set the activity_sequence_number to 1
    if @trip_activities.size < 1
      @trip_activity.activity_sequence_number = 1
    else
      #if we have more than one activity, get last activity sequence
      #and set this new activity's position (in the form field), to n+1
      @trip_activity.activity_sequence_number = @trip_activities.last.activity_sequence_number+1
    end
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @trip_activity }
    end
  end

  # GET /trip_activities/1/edit
  def edit
    begin
      @trip_activity = @trip.trip_activities.find(params[:id])
      @latlong = find_location_latlong @trip
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = "Trip activity not found"
      redirect_to :controller => 'trips', :action => 'index'
      return
    end
  end

  def report_error format, object
    logger.info "error"
    format.html { render action: "new" }
    format.json { render json: object.errors, status: :unprocessable_entity }
  end
  
  # POST /trip_activities
  # POST /trip_activities.json
  def create
    @trip_activity = nil
    @activity = nil
    @activity_detail = nil
    respond_to do |format|
      if (params[:trip_activity][:activity_type] == "FoodActivity" or params[:trip_activity][:activity_type] == "LocationActivity" or params[:trip_activity][:activity_type] == "TransportActivity")
        if params[:trip_activity][:activity_type] == "FoodActivity"
          logger.info "food activity..."  
          @activity = FoodActivity.new(params[:food_activity])
          @activity.image_urls = params[:selected_images]
          @activity_detail = @activity.restaurant_detail
          if (@activity_detail.nil? or @activity_detail == 0)
            @activity_detail = create_food_venue(@activity[:restaurant_detail_id], @trip.location_id)
            @activity.restaurant_detail = @activity_detail
          end
        elsif params[:trip_activity][:activity_type] == "TransportActivity"
          logger.info "transport acitivity"
          @activity_detail = ""
          @activity = TransportActivity.new(params[:transport_activity])
        elsif params[:trip_activity][:activity_type] == "LocationActivity"
          logger.info "location acitivity"
          @activity = LocationActivity.new(params[:location_activity])
          @activity.image_urls = params[:selected_images]
          @activity_detail = @activity.location_detail
          if (@activity_detail.nil? or @activity_detail == 0)
            @activity_detail = create_location_venue(@activity[:location_detail_id], @trip.location_id)
            @activity.location_detail = @activity_detail
          end
        end   
      
        if @activity_detail == nil or @activity_detail.errors.any?
          if @activity_detail.nil?
          else
            logger.info "activity detail errors #{@activity_detail.inspect.errors} "
          end
          format.html { redirect_to new_trip_trip_activity_path(@trip), notice: 'Error during activity creation, retry.'  }
          format.json { render json: @activity_detail.errors, status: :unprocessable_entity }    
        else
          if !(@activity and @activity.save)
            logger.info "\n activity errors #{@activity.errors.messages} "
            format.html { redirect_to new_trip_trip_activity_path(@trip), notice: @activity.errors.full_messages.to_sentence }
            format.json { render json: @activity.errors, status: :unprocessable_entity }    
          else        
            @trip_activity = @trip.trip_activities.create(:activity => @activity, \
            :activity_day => params[:trip_activity][:activity_day], \
            :activity_sequence_number => params[:trip_activity][:activity_sequence_number], \
            :activity_time_type => params[:trip_activity][:activity_time_type])
            if @trip_activity.save
              format.html { redirect_to new_trip_trip_activity_path(@trip), notice: 'Trip activity was successfully created.' }
              format.json { render json: @trip_activity, status: :created, location: @trip_activity }
            else
              @activity.destroy # clean up
              @latlong = find_location_latlong @trip
              format.html { render action: "new", notice: @trip_activity.errors.full_messages.to_sentence  }
              format.json { render json: @trip_activity.errors, status: :unprocessable_entity }
            end
          end
        end
      else
        logger.info "invalid value activity type "
        format.html { redirect_to new_trip_trip_activity_path(@trip), notice: 'invalid activity selected' }
        format.json { render json: @trip_activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /trip_activities/1
  # PUT /trip_activities/1.json
  def update
    begin
      @trip_activity = @trip.trip_activities.find(params[:id])
      @activity = @trip_activity.activity
      @trip_activities = @trip.trip_activities.all.sort_by {|e| e[:activity_sequence_number]}
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = "Trip activity not found"
      redirect_to :controller => 'trips', :action => 'index'
      return
    end
    
    respond_to do |format|
      if params[:trip_activity][:activity_type] == "FoodActivity"
        @activity.image_urls = (params[:selected_images] != "") ? params[:selected_images] : @activity.image_urls
        values = params[:food_activity]
      elsif params[:trip_activity][:activity_type] == "TransportActivity"
        values = params[:transport_activity]
      elsif params[:trip_activity][:activity_type] == "LocationActivity"
        @activity.image_urls = (params[:selected_images] != "") ? params[:selected_images] : @activity.image_urls
        values = params[:location_activity]
      end        
      if (@activity.update_attributes(values) == false)
        format.html { render action: "edit", notice: @activity.errors.full_messages.to_sentence }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
      else
        if @trip_activity.update_attributes(params[:trip_activity])
          format.html { redirect_to trip_trip_activities_path(@trip), notice: 'Trip activity was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit", notice: @trip_activity.errors.full_messages.to_sentence}
          format.json { render json: @trip_activity.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /trip_activities/1
  # DELETE /trip_activities/1.json
  def destroy
    begin
      @trip_activity = @trip.trip_activities.find(params[:id])
      # this is not tested and a very crude way to delete the trip
      @trip_activity.activity.destroy
      @trip_activity.destroy
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = "Trip activity not found"
      redirect_to :controller => 'trips', :action => 'index'
      return
    end
    respond_to do |format|
      format.html { redirect_to @trip }
      format.json { head :no_content }
    end
  end

  def showpartial
    #logger.info "active #{params.inspect}"
    # @trip_activity = @trip.trip_activities(params[:id])
    begin
      @trip_activity = TripActivity.find(params[:activityid])
      @partial_layout = params[:layout]
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = "Trip activity not found"
      redirect_to :controller => 'trips', :action => 'index'
      return
    end
       
    render :partial => "trip_activities/#{@partial_layout}", :locals => {:trip_activity => @trip_activity}, :layout => false
  end

  # GET /trips/:id/trip_activities/:activity_id/mapinfo
  def mapinfo
    #logger.info { "mapinfo #{params.inspect}"}
    begin
      @trip_activity = @trip.trip_activities.find(params[:id])
      @trip_details = @trip_activity.prev_activities_sequence_number
      @current_activity = params[:id]
      #logger.info { "\n\ntripdetails...  #{@trip_details.inspect}"}
    
      @trip_map_info = view_context.get_trip_map_info @trip_details, @current_activity
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = "Trip activity not found"
      redirect_to :controller => 'trips', :action => 'index'
      return
    end
    
    #logger.info "here #{@trip_map_info.inspect}"
    respond_to do |format|
      format.html # mapinfo.html.erb
      format.json { render json: @trip_map_info  } 
    end
  end

  def move
    if ["move_lower", "move_higher", "move_to_top", "move_to_bottom"].include?(params[:method]) and params[:trip_activity_id] =~ /^\d+$/
     #if the incoming params contain any of these methods and a numeric trip_activity_id, 
     #let's find the activity with that id and send it the acts_as_list specific method
     #that rode in with the params from whatever link was clicked on
       @trip.trip_activities.find(params[:trip_activity_id]).send(params[:method])
    end
    @trip_activities = @trip.trip_activities.all.sort_by {|e| e[:activity_sequence_number]}
    #after we're done updating the position (which gets done in the background
    #because of acts_as_list, we'll use ajax to reload the page
    respond_to do |format|
      format.js # index.js.erb
    end
  end


  def load_trip
    begin
      @trip = Trip.find(params[:trip_id])
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = "Trip not found"
      redirect_to :controller => 'trips', :action => 'index'
      return
    end
  end

end
