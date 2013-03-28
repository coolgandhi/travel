class TripsController < ApplicationController
  include TripsHelper
  before_filter :authorize, :except => [:index, :show, :showpartial]
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
    
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = "Trip not found"
      redirect_to :controller => 'trips', :action => 'index'
      return
    end 

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
      
      @trip.trip_activities.each {|trip_activity| 
        trip_activity.activity.destroy }
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

  def trips_admin
    @trips = Trip.all
    
    respond_to do |format|
      format.html # index.html.erb
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
