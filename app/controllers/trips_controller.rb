class TripsController < ApplicationController
  include TripsHelper
  layout "showtriplayout", :only => [:show]
  # GET /trips
  # GET /trips.json
  def index
    @trips, @message_with_trip_render = Trip.search(params)
    @trips, @message_with_trip_render = get_trips_filtered_by_landmarks(params, @trips, @message_with_trip_render)
    @locations = nil
    @restaurants = nil
    if (params[:trip_location_id] and params[:trip_location_id] != "" and (params[:page] == nil or params[:page] == "1"))
      # generate landmark of interest only for the initial trip search with location, not while paginating 
      @locations = LocationDetail.search(params[:trip_location_id])
      @restaurants = RestaurantDetail.search(params[:trip_location_id])
    end
    
    @trips = @trips.paginate(:page => (params[:page] && params[:page] != "")?params[:page] : "1", :per_page => (params[:per_page] && params[:per_page] != "")?params[:per_page].to_i : 5)
    
   # logger.info "#{@trips.inspect}"
    respond_to do |format|
      format.html # index.html.erb
      format.js # index.js.erb
      format.json { render json: @trips }
    end
  end

  # GET /trips/1
  # GET /trips/1.json
  def show
    @trip = Trip.find(params[:id])
    @author = @trip.author_info
    @sorted_activities, @compressed_activities = sorted_trip_activities @trip
     
    #logger.info "show trip #{@sorted_activities.inspect}"    
    respond_to do |format|
      format.html # show.html.erb
      format.json { 
          render :json => { :compressed_activity => @compressed_activities } 
      }
    end
  end

  # GET /trips/new
  # GET /trips/new.json
  def new
    @trip = Trip.new
    @author_info = AuthorInfo.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @trip }
    end
  end

  # GET /trips/1/edit
  def edit
    @trip = Trip.find(params[:id])
  end

  # POST /trips
  # POST /trips.json
  def create
    @trip = Trip.new(params[:trip])
    @trip.image_url = params[:selected_images]
    @author_info = AuthorInfo.find_by_email(params[:author_email].downcase)
    if @author_info.nil?
      @author_info = AuthorInfo.new
      @author_info.author_name = params[:author_name]
      @author_info.email = params[:author_email].downcase
    end
    
    respond_to do |format|
      if @author_info.save
        @trip.author_id = @author_info.id
      else
        @trip.author_id = "a"
        format.html { render action: "new" }
        format.json { render json: @author_info.errors, status: :unprocessable_entity }
      end
      
      if @trip.save
        format.html { redirect_to @trip, notice: 'Trip was successfully created.' }
        format.json { render json: @trip, status: :created, location: @trip }
      else
        format.html { render action: "new" }
        format.json { render json: @trip.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /trips/1
  # PUT /trips/1.json
  def update
    @trip = Trip.find(params[:id])

    respond_to do |format|
      if @trip.update_attributes(params[:trip])
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
    @trip = Trip.find(params[:id])
    @trip.destroy

    respond_to do |format|
      format.html { redirect_to trips_url }
      format.json { head :no_content }
    end
  end

  def showpartial
    #logger.info "trictive #{params.inspect}"
    
    @trip = Trip.find(params[:id])
    @author = @trip.author_info
    
    @partial_layout = params[:layout]
    render :partial => "#{@partial_layout}", :layout => false
  end

end
