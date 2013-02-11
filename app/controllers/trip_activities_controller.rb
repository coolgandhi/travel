class TripActivitiesController < ApplicationController
  include ApplicationHelper
  include TripActivitiesHelper
  before_filter :load_trip
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
    @trip_activity = @trip.trip_activities.find(params[:id])
    
    #logger.info " here... #{@trip_activity.activity.inspect}"
    respond_to do |format| require 'trip_activities_controller'
      format.html # show.html.erb
      format.json { render json: @trip_activity }
    end
  end

  # GET /trip_activities/new
  # GET /trip_activities/new.json
  def new
    @trip_activity = @trip.trip_activities.new
    @trip_activity.trip_id = params[:trip_id]
    @latlong = nil
    #logger.info (" here ... #{@trip.inspect}")
    @location_detail = Location.find_by_location_id(@trip.location_id)
    if (@location_detail)
      @latlong = @location_detail.latitude + "," + @location_detail.longitude
    else
      @latlong = "37.77493,-122.41942"  # use SF by default
    end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @trip_activity }
    end
  end

  # GET /trip_activities/1/edit
  def edit
    @trip_activity = @trip.trip_activities.find(params[:id])
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
    #logger.info"#{params.inspect}"
    respond_to do |format|
      if params[:trip_activity][:activity_type] == "FoodActivity"
        logger.info "food activity..."  
        @activity = FoodActivity.new(params[:food_activity])
        @activity.image_urls = params[:selected_images]
        if (@activity.restaurant_detail.nil? or @activity.restaurant_detail == 0)
          @activity.restaurant_detail = create_food_venue(@activity[:restaurant_detail_id])
        end
      elsif params[:trip_activity][:activity_type] == "TransportActivity"
        logger.info "transport acitivity"
        @activity = TransportActivity.new(params[:transport_activity])
      elsif params[:trip_activity][:activity_type] == "LocationActivity"
        logger.info "location acitivity"
        @activity = LocationActivity.new(params[:location_activity])
        @activity.image_urls = params[:selected_images]
        if (@activity.location_detail.nil? or @activity.location_detail == 0)
          @activity.location_detail = create_location_venue(@activity[:location_detail_id])
        end
      end 
    
      if @activity && @activity.save
        @trip_activity = @trip.trip_activities.create(:activity => @activity, \
        :activity_day => params[:trip_activity][:activity_day], \
        :activity_sequence_number => params[:trip_activity][:activity_sequence_number], \
        :activity_time_type => params[:trip_activity][:activity_time_type])
        if @trip_activity.save
          format.html { redirect_to @trip, notice: 'Trip activity was successfully created.' }
          format.json { render json: @trip_activity, status: :created, location: @trip_activity }
        else
          report_error format, @trip_activity
        end
      else
        report_error format, @activity
      end
    end
  end

  # PUT /trip_activities/1
  # PUT /trip_activities/1.json
  def update
    @trip_activity = @trip.trip_activities.find(params[:id])

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
    @trip_activity = @trip.trip_activities.find(params[:id])
    @trip_activity.destroy

    respond_to do |format|
      format.html { redirect_to @trip }
      format.json { head :no_content }
    end
  end


  # GET /trips/1
  # GET /trips/1.json
  def carddeck
    @trip_activity = @trip.trip_activities.find(params[:id])
    #logger.info " here.... #{trip_activity.inspect}"
       
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @trip_activity }
      format.js
    end
  end

  def showpartial
    #logger.info "active #{params.inspect}"
    # @trip_activity = @trip.trip_activities(params[:id])
    @trip_activity = TripActivity.find(params[:activityid])
    @partial_layout = params[:layout]
       
    render :partial => "trip_activities/#{@partial_layout}", :locals => {:trip_activity => @trip_activity}, :layout => false
  end

  # GET /trips/:id/trip_activities/:activity_id/mapinfo
  def mapinfo
    #logger.info { "mapinfo #{params.inspect}"}
    @trip_activity = @trip.trip_activities.find(params[:id])
    @trip_details = @trip_activity.prev_activities_activity_id
    #logger.info { "\n\ntripdetails...  #{@trip_details.inspect}"}
    
    @trip_map_info = get_trip_map_info @trip_details
    
    logger.info "here #{@trip_map_info.inspect}"
    respond_to do |format|
      format.html # mapinfo.html.erb
      format.json { render json: @trip_map_info  } 
    end
  end

  def load_trip
    @trip = Trip.find(params[:trip_id])
  end

end
