class TripActivitiesController < ApplicationController
  # GET /trip_activities
  # GET /trip_activities.json
  def index
    @trip_activities = TripActivity.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @trip_activities }
    end
  end

  # GET /trip_activities/1
  # GET /trip_activities/1.json
  def show
    @trip_activity = TripActivity.find(params[:id])
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

  # GET /trip_activities/new
  # GET /trip_activities/new.json
  def new
    @trip_activity = TripActivity.new
    @trip_activity.trip_id = params[:trip_id]
#    logger.info("PARAMS: #{params.inspect}")

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @trip_activity }
    end
  end

  # GET /trip_activities/1/edit
  def edit
    @trip_activity = TripActivity.find(params[:id])
  end

  # POST /trip_activities
  # POST /trip_activities.json
  def create
    @trip_activity = TripActivity.new(params[:trip_activity])
    @trip_activity.trip_id = params[:trip_id]
    @activity = nil
#    logger.info("PARAMS: #{params.inspect}")
#    logger.info "New post: #{@trip_activity.attributes.inspect}"
   
    respond_to do |format|
      if @trip_activity[:activity_type] == "1"
         logger.info "food activity..."
         @activity = FoodActivity.new(params[:food_activity])
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
         format.html { redirect_to @trip_activity, notice: 'Trip activity was successfully created.' }
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
    @trip_activity = TripActivity.find(params[:id])

    respond_to do |format|
      if @trip_activity.update_attributes(params[:trip_activity])
        format.html { redirect_to @trip_activity, notice: 'Trip activity was successfully updated.' }
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
    @trip_activity = TripActivity.find(params[:id])
    @trip_activity.destroy

    respond_to do |format|
      format.html { redirect_to trip_activities_url }
      format.json { head :no_content }
    end
  end
end
