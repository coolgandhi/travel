class TripsController < ApplicationController
  include TripsHelper
  before_filter :authorize, :except => [:index, :show, :showpartial]
  layout :resolve_layout
  # GET /trips
  # GET /trips.json
  def index
    @trips, @message_with_trip_render = Trip.search(params)
    @trips, @message_with_trip_render = get_trips_filtered_by_landmarks(params, @trips, @message_with_trip_render)
    @locations = nil
    @restaurants = nil
    @traveler_types = nil
    
    if (params[:trip_location_id] and params[:trip_location_id] != "" and (params[:page] == nil or params[:page] == "1"))
      # generate landmark of interest only for the initial trip search with location, not while paginating 
      @locations = LocationDetail.search(params[:trip_location_id])
      @restaurants = RestaurantDetail.search(params[:trip_location_id])
      
      if (params[:traveler_type_id])
        @traveler_types = TravelerType.where("traveler_type_id IN (?)", params[:traveler_type_id])
      end
    end
    
    @trips = @trips.paginate(:page => (params[:page] && params[:page] != "")?params[:page] : "1", :per_page => (params[:per_page] && params[:per_page] != "")?params[:per_page].to_i : 3)
    
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
    begin
      @trip = Trip.find(params[:id])
      @author = @trip.author_info
      @sorted_activities, @compressed_activities = sorted_trip_activities @trip
    
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = "Trip not found"
      redirect_to :controller => 'trips', :action => 'index'
      return
    end 

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
    begin  
      @trip = Trip.find(params[:id])
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
    begin  
      @trip = Trip.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = "Trip not found"
      redirect_to :controller => 'trips', :action => 'index'
      return
    end 

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
    begin
      @trip = Trip.find(params[:id])
      @trip.destroy
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = "Trip not found"
      redirect_to :controller => 'trips', :action => 'index'
      return
    end 

    respond_to do |format|
      format.html { redirect_to trips_url }
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

  # def admin
  #   @trips = Trip.all
    
  #   respond_to do |format|
  #     format.html # index.html.erb
  #     format.json { render json: @trip_activities }
  #   end
  # end

  private

  def resolve_layout
    case action_name
    when "show"
      "showtriplayout"
    when "index"
      "index_layout"
    else
      "application"
    end
  end

end
