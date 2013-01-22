class TripActivitiesController < ApplicationController
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
    @trip_activities_detail = nil

    if @trip_activity[:activity_type] == "1"
      logger.info "food activity..."  
      if @trip_activity[:activity_id]
        begin 
          @trip_activities_detail = FoodActivity.find(@trip_activity[:activity_id])
        rescue ActiveRecord::RecordNotFound
          logger.info "food activity entry not found"
        end
      end
    elsif @trip_activity[:activity_type] == "2"
      logger.info "transport acitivity" 
      if @trip_activity[:activity_id] 
        begin
          @trip_activities_detail = TransportActivity.find(@trip_activity[:activity_id])
        rescue ActiveRecord::RecordNotFound
          logger.info "transport activity entry not found"
        end
      end
    elsif @trip_activity[:activity_type] == "3"
      logger.info "location activity"
      if @trip_activity[:activity_id] 
        begin  
          @trip_activities_detail = LocationActivity.find(@trip_activity[:activity_id])
        rescue ActiveRecord::RecordNotFound
          logger.info "location activity entry not found"
        end
      end
    else
      logger.info "invalid option in setting up a trip... trip activity type is not one of the known valeues."
      @trip_activities_detail[@trip_activity[:activity_id]] = nil
    end
    
    respond_to do |format|require 'trip_activities_controller'
    
      format.html # show.html.erb
      format.json { render json: @trip_activity }
    end
  end

  # GET /trip_activities/new
  # GET /trip_activities/new.json
  def new
    @trip_activity = @trip.trip_activities.new
  #  logger.info "New post: #{@trip.attributes.inspect}"
    @trip_activity.trip_id = params[:trip_id]
    @latlong = nil
    begin  
      @location_detail = Location.find_by_location_id(@trip.location_id)
      @latlong = @location_detail.latitude + "," + @location_detail.longitude
    rescue ActiveRecord::RecordNotFound
        @latlong = "37.77493,-122.41942"  # use SF by default
        logger.info "location detail entry not found"
    end
#    logger.info("PARAMS: #{params.inspect}")

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @trip_activity }
    end
  end

  # GET /trip_activities/1/edit
  def edit
    @trip_activity = @trip.trip_activities.find(params[:id])
  end

  # POST /trip_activities
  # POST /trip_activities.json
  def create
    @trip_activity = @trip.trip_activities.new(params[:trip_activity])
    @trip_activity.trip_id = params[:trip_id]
    @activity = nil
    @activity_detail = nil
#    logger.info("PARAMS: #{params.inspect}")
#    logger.info "New post: #{@trip_activity.attributes.inspect}"
    respond_to do |format|
      
      if @trip_activity[:activity_type] == "1"
        logger.info "food activity..."  
        @activity = params[:food_activity]
          @activity_detail = RestaurantDetail.find_by_restaurant_detail_id(@activity[:restaurant_detail_id])
          logger.info ("here #{@activity_detail.food_activity.inspect}")
          if (@activity_detail.nil? or @activity_detail == 0)
            @venue = FoursquareInteraction.venue_info(@activity[:restaurant_detail_id])
            @venue_tips = FoursquareInteraction.venue_tips(@activity[:restaurant_detail_id])
            @activity_detail = RestaurantDetail.new 
             tag = ""
            if @venue[:description] 
              tag = tag + @venue[:description] + " "
            elsif @venue.has_key?(:page)
              begin
                temp_copy = @venue[:page][:pageInfo][:description]
                tag = tag + temp_copy + " "
              rescue
                # do nothing
              end
            end
            
            @venue[:tags].each { |ven_tag|
                 tag = tag + ven_tag + " "
            }
            
            open_hours = ""
            if @venue[:hours]
              @venue[:hours][:timeframes].each { |timeframes_tag|
                open_hours = open_hours + timeframes_tag[:days] + " "
                timeframes_tag[:open].each { |open_tag|
                  open_hours = open_hours + open_tag[:renderedTime] + " "   
                }
                open_hours = open_hours + ", "
              }
            end
            
            @activity_detail.attributes = { :restaurant_detail_id => @venue[:id], :address1 => @venue[:location][:address], :city => @venue[:location][:city], :address2 => @venue[:location][:crossStreet], :country => @venue[:location][:country], :state => @venue[:location][:state], :latitude => @venue[:location][:lat].to_s, :longitude => @venue[:location][:lng].to_s, :phone => @venue[:contact][:formattedPhone], :zip => @venue[:location][:postalCode], :name => @venue[:name], :website => @venue[:url], :category => ( @venue[:categories].first[:name] + ", " + @venue[:categories].first[:parents].first), :description => tag, :open_hours => open_hours}
           
           # get tips for description
          #  logger.info " here you go #{@activity_detail.inspect}"
            
            if @activity_detail.save
            else
              logger.info "food detail error"
            end
          end
          #@activity_detail = RestaurantDetail.new       
      elsif @trip_activity[:activity_type] == "2"
        logger.info "transport acitivity"

      elsif @trip_activity[:activity_type] == "3"
        logger.info "location acitivity"
        @activity = params[:location_activity]
#location_detail_id, :address1, :address2, :address3, :category, :city, :country, :description, :latitude, :longitude, :name, :open_hours, :phone, :state, :website, :zip
        @activity_detail = LocationDetail.find_by_location_detail_id(@activity[:location_detail_id])
        if (@activity_detail.nil? or @activity_detail == 0)
          @venue = FoursquareInteraction.venue_info(@activity[:location_detail_id])
          @venue_tips = FoursquareInteraction.venue_tips(@activity[:location_detail_id])
          @activity_detail = LocationDetail.new
           tag = ""
          if @venue[:description] 
            tag = tag + @venue[:description] + " "
          elsif @venue.has_key?(:page)
            begin
              temp_copy = @venue[:page][:pageInfo][:description]
              tag = tag + temp_copy + " "
            rescue
              # do nothing
            end
          end
          
          @venue[:tags].each { |ven_tag|
               tag = tag + ven_tag + " "
          }
          
          open_hours = ""
          if @venue[:hours]
            @venue[:hours][:timeframes].each { |timeframes_tag|
              open_hours = open_hours + timeframes_tag[:days] + " "
              timeframes_tag[:open].each { |open_tag|
                open_hours = open_hours + open_tag[:renderedTime] + " "   
              }
              open_hours = open_hours + ", "
            }
          end
          
          @activity_detail.attributes = { :location_detail_id => @venue[:id], :address1 => @venue[:location][:address], :city => @venue[:location][:city], :address2 => @venue[:location][:crossStreet], :country => @venue[:location][:country], :state => @venue[:location][:state], :latitude => @venue[:location][:lat].to_s, :longitude => @venue[:location][:lng].to_s, :phone => @venue[:contact][:formattedPhone], :zip => @venue[:location][:postalCode], :name => @venue[:name], :website => @venue[:url], :category => ( @venue[:categories].first[:name] + ", " + @venue[:categories].first[:parents].first), :description => tag, :open_hours => open_hours}
         
           # get tips for description
           logger.info " here you go #{@activity_detail.inspect}"
          if @activity_detail.save
          else
            logger.info "food detail error"
          end
        end
      else
        logger.info "invalid option in setting up a trip... trip activity type is not one of the known valeues."
        @trip_activities_detail[@trip_activity[:activity_id]] = nil      
      end
      
      
      if @trip_activity[:activity_type] == "1"
         logger.info "food activity..."
         @activity = FoodActivity.new(params[:food_activity])
         logger.info "inspect #{@activity.restaurant_detail.inspect}   \n #{@activity.inspect}"
         if @activity.save
           @trip_activity.activity_id = @activity.id
         else
           logger.info "food error"
           format.html { render action: "new" }
           format.json { render json: @trip_activity.errors, status: :unprocessable_entity }  
         end
      elsif @trip_activity[:activity_type] == "2"
         logger.info "transport acitivity" 
         @activity = TransportActivity.new(params[:transport_activity])
        
         if @activity.save
           @trip_activity.activity_id = @activity.id
         else
           logger.info "transport error"
           format.html { render action: "new" }
           format.json { render json: @trip_activity.errors, status: :unprocessable_entity }  
         end 
      elsif @trip_activity[:activity_type] == "3"
         logger.info "location activity"
         @activity = LocationActivity.new(params[:location_activity])
         if @activity.save
            @trip_activity.activity_id = @activity.id
         else              
           logger.info "location error"
           format.html { render action: "new" }
           format.json { render json: @trip_activity.errors, status: :unprocessable_entity }  
         end
      else
         logger.info "activity type error"
         format.html { render action: "new" }
         format.json { render json: @trip_activity.errors, status: :unprocessable_entity }  
      end
      
       if @trip_activity.save
         format.html { redirect_to @trip, notice: 'Trip activity was successfully created.' }
         format.json { render json: @trip_activity, status: :created, location: @trip_activity }
       else
         logger.info "trip activity error"
         format.html { render action: "new" }
         format.json { render json: @trip_activity.errors, status: :unprocessable_entity }
       end
     #   format.html { redirect_to @trip_activity, notice: 'Trip activity was successfully created.' }
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
    @trip_activities_detail = nil

      if @trip_activity[:activity_type] == "1"
          logger.info "food activity..."  
          if @trip_activity[:activity_id]
            begin 
              @trip_activities_detail = FoodActivity.find(@trip_activity[:activity_id])
            rescue ActiveRecord::RecordNotFound
              logger.info "food activity entry not found"
            end
          end
       elsif @trip_activity[:activity_type] == "2"
          logger.info "transport acitivity" 
          if @trip_activity[:activity_id] 
            begin
              @trip_activities_detail = TransportActivity.find(@trip_activity[:activity_id])
            rescue ActiveRecord::RecordNotFound
              logger.info "transport activity entry not found"
            end
          end
       elsif @trip_activity[:activity_type] == "3"
          logger.info "location activity"
          if @trip_activity[:activity_id] 
            begin  
              @trip_activities_detail = LocationActivity.find(@trip_activity[:activity_id])
            rescue ActiveRecord::RecordNotFound
              logger.info "location activity entry not found"
            end
          end
       else
        logger.info "invalid option in setting up a trip... trip activity type is not one of the known valeues."
        @trip_activities_detail[@trip_activity[:activity_id]] = nil
       end
       
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @trip_activity }
    end
  end

  def load_trip
    @trip = Trip.find(params[:trip_id])
  end

end
