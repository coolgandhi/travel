class TripActivitiesController < ApplicationController
  include ApplicationHelper
  include TripActivitiesHelper
  before_filter :load_trip
  before_filter :authorize, :except => [:mapinfo, :carddeck, :showpartial]
  # GET /trip_activities
  # GET /trip_activities.json
  def index
    @trip_activities = @trip.trip_activities.all

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
    respond_to do |format|
      if params[:trip_activity][:activity_type] == "FoodActivity"
        logger.info "food activity..."  
        @activity = FoodActivity.new(params[:food_activity])
        @activity.image_urls = params[:selected_images]
        if (@activity.restaurant_detail.nil? or @activity.restaurant_detail == 0)
          @activity.restaurant_detail = create_food_venue(@activity[:restaurant_detail_id], @trip.location_id)
        end
      elsif params[:trip_activity][:activity_type] == "TransportActivity"
        logger.info "transport acitivity"
        @activity = TransportActivity.new(params[:transport_activity])
      elsif params[:trip_activity][:activity_type] == "LocationActivity"
        logger.info "location acitivity"
        @activity = LocationActivity.new(params[:location_activity])
        @activity.image_urls = params[:selected_images]
        if (@activity.location_detail.nil? or @activity.location_detail == 0)
          @activity.location_detail = create_location_venue(@activity[:location_detail_id], @trip.location_id)
        end
      end 
    
      err = 0;
      if @activity and @activity.save
      else
        err = 1;
      end
        
      @trip_activity = @trip.trip_activities.create(:activity => @activity, \
      :activity_day => params[:trip_activity][:activity_day], \
      :activity_sequence_number => params[:trip_activity][:activity_sequence_number], \
      :activity_time_type => params[:trip_activity][:activity_time_type])
      if err == 0 and @trip_activity.save 
        format.html { redirect_to new_trip_trip_activity_path(@trip), notice: 'Trip activity was successfully created.' }
        format.json { render json: @trip_activity, status: :created, location: @trip_activity }
      else
        @latlong = find_location_latlong @trip
        format.html { render action: "new" }
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
      if params[:trip_activity][:activity_type] == "FoodActivity"
        @activity.image_urls = (params[:selected_images] != "") ? params[:selected_images] : @activity.image_urls
        if (@activity.update_attributes(params[:food_activity]) == false)
          format.html { render action: "edit" }
          format.json { render json: @trip_activity.errors, status: :unprocessable_entity }
          return
        end 
      elsif params[:trip_activity][:activity_type] == "TransportActivity"
        if (@activity.update_attributes(params[:transport_activity]) == false)
          format.html { render action: "edit" }
          format.json { render json: @trip_activity.errors, status: :unprocessable_entity }
          return
        end  
      elsif params[:trip_activity][:activity_type] == "LocationActivity"
        @activity.image_urls = (params[:selected_images] != "") ? params[:selected_images] : @activity.image_urls
        if (@activity.update_attributes(params[:location_activity]) == false)
          format.html { render action: "edit" }
          format.json { render json: @trip_activity.errors, status: :unprocessable_entity }
          return    
        end 
        
      end
        
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = "Trip activity not found"
      redirect_to :controller => 'trips', :action => 'index'
      return
    end

    respond_to do |format|
      if @trip_activity.update_attributes(params[:trip_activity])
        format.html { redirect_to trip_url(@trip), notice: 'Trip activity was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @trip_activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trip_activities/1
  # DELETE /trip_activities/1.json
  def destroy
    begin
      @trip_activity = @trip.trip_activities.find(params[:id])
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


  # GET /trips/1
  # GET /trips/1.json
  def carddeck
    begin
      @trip_activity = @trip.trip_activities.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = "Trip activity not found"
      redirect_to :controller => 'trips', :action => 'index'
      return
    end
        
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @trip_activity }
      format.js
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
    
      @trip_map_info = get_trip_map_info @trip_details, @current_activity
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
