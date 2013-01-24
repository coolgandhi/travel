class TripsController < ApplicationController
  layout "showtriplayout", :only => [:show]
  # GET /trips
  # GET /trips.json
  def index
    
    @trips = Trip.all
    #logger.info "here..."
    #@trips = nil
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @trips }
    end
  end

  # GET /trips/1
  # GET /trips/1.json
  def show
    @trip = Trip.find(params[:id])
    @trip_activities = TripActivity.find_all_by_trip_id(params[:id])
    @trip_activities_details = Hash.new
#    logger.info "New post: #{@trip_activities.attributes.inspect}"
    @trip_activities.each do |trip_activity|
       if trip_activity[:activity_type] == "1"
          logger.info "food activity..."  
          if trip_activity[:activity_id]
            begin 
              @trip_activities_details[trip_activity[:activity_id]] = FoodActivity.find(trip_activity[:activity_id])
            rescue ActiveRecord::RecordNotFound
              logger.info "food activity entry not found"
            end
          end
       elsif trip_activity[:activity_type] == "2"
          logger.info "transport acitivity" 
          if trip_activity[:activity_id] 
            begin
              @trip_activities_details[trip_activity[:activity_id]] = TransportActivity.find(trip_activity[:activity_id])
            rescue ActiveRecord::RecordNotFound
              logger.info "transport activity entry not found"
            end
          end
       elsif trip_activity[:activity_type] == "3"
          logger.info "location activity"
          if trip_activity[:activity_id] 
            begin  
              @trip_activities_details[trip_activity[:activity_id]] = LocationActivity.find(trip_activity[:activity_id])
            rescue ActiveRecord::RecordNotFound
              logger.info "location activity entry not found"
            end
          end
       else
        logger.info "invalid option in setting up a trip... trip activity type is not one of the known valeues."
        @trip_activities_details[trip_activity[:activity_id]] = nil
       end
        
    end
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => { :trip=> @trip,
                                     :trip_activity => @trip_activities,
                                     :trip_activities_details => @trip_activities_details
                                   } 
      }
    end
  end

  # GET /trips/new
  # GET /trips/new.json
  def new
    @trip = Trip.new

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
    logger.info "New post: #{@trip.attributes.inspect}"
    respond_to do |format|
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
    @trip = Trip.find(params[:id])
    @partial_layout = params[:layout]
    render :partial => "#{@partial_layout}", :layout => false
  end

end
