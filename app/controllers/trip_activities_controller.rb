class TripActivitiesController < ApplicationController
  include ApplicationHelper
  include TripActivitiesHelper
  before_filter :load_trip
  before_filter :authorize, :except => [:mapinfo, :showpartial]
  # GET /trip_activities
  # GET /trip_activities.json
  def index
    # @trip_activities = @trip.trip_activities.all.sort_by {|e| e[:activity_sequence_number]}
    @trip_activities = @trip.trip_activities.all(:order => "activity_day asc, activity_sequence_number asc")
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
            if params[:self_trip_activity_photos] != nil
             @photo = @trip_activity.self_trip_activity_photos.new(params[:self_trip_activity_photos])
             if @photo.save
               format.html { redirect_to new_trip_trip_activity_path(@trip), notice: 'Trip activity was successfully created.' }
               format.json { render json: @trip_activity, status: :created, location: @trip_activity }
             else
               @activity.destroy # clean up
               @latlong = find_location_latlong @trip
               format.html { render action: "new", notice: @photo.errors.full_messages.to_sentence  }
               format.json { render json: @trip_activity.errors, status: :unprocessable_entity }
             end
            else
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
      @trip.trip_activities.find(params[:trip_activity_id]).update_attribute(:activity_time_type, params[:time_type])
    elsif ["no_move"].include?(params[:method]) and params[:trip_activity_id] =~ /^\d+$/
      @trip.trip_activities.find(params[:trip_activity_id]).update_attribute(:activity_time_type, params[:time_type])
    end
    @trip_activities = @trip.trip_activities.all.sort_by {|e| e[:activity_sequence_number]}
    #after we're done updating the position (which gets done in the background
    #because of acts_as_list, we'll use ajax to reload the page
    respond_to do |format|
      format.js
    end
  end
  
  def show_activity_photos
    begin
      @trip_activity = @trip.trip_activities.find(params[:id])
      @self_images = @trip_activity.self_trip_activity_photos
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = "Trip activity not found"
      redirect_to :controller => 'trips', :action => 'index'
      return
    end  
   respond_to do |format|
     format.html # showactivityimages.html.erb
     format.json { render json: @self_images.self_photo  } 
   end
  end
  
  def add_new_photo
    begin
      @trip_activity = @trip.trip_activities.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = "Trip activity not found"
      redirect_to :controller => 'trips', :action => 'index'
      return
    end  
    
    respond_to do |format|
      @photo = @trip_activity.self_trip_activity_photos.new(params[:self_trip_activity_photos])
      if @photo.save
       format.html { redirect_to show_activity_photos_trip_trip_activity_path(@trip, @trip_activity), notice: 'Photo added successfully.' }
      else
       format.html { render action: "new", notice: @photo.errors.full_messages.to_sentence  }
       format.json { render json: @trip_activity.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def publish_trip_activity_edit
    begin
      @trip_activity = @trip.trip_activities.find(params[:id])
      @latlong = find_location_latlong @trip
      @activity = @trip_activity.activity
      @latlong = find_location_latlong @trip
      @update = 1
      case @trip_activity.activity_type
        when "LocationActivity"
          @activity_detail = @activity.location_detail
          params[:description] = @activity.description 
          params[:duration] = @activity.duration 
          params[:quick_tip] = @activity.quick_tip 
          params[:selected_images] = @activity.image_urls 
          params[:venueid]  = @activity.location_detail_id 
        when "TransportActivity"
          @activity_detail = nil
        when "FoodActivity"
          @activity_detail = @activity.restaurant_detail
          params[:description] = @activity.description 
          params[:duration] = @activity.duration 
          params[:quick_tip] = @activity.quick_tip 
          params[:selected_images] = @activity.image_urls 
          params[:venueid]  = @activity.restaurant_detail_id
      end
      
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = "Trip activity not found"
      redirect_to :controller => 'trips', :action => 'index'
      return
    end
    respond_to do |format|
      format.js
    end
  end
  
  def publish_trip_activity_update
    begin
      @status = 0
      @update = 1
      @trip_activity = @trip.trip_activities.find(params[:id])
      @activity = @trip_activity.activity
      @latlong = find_location_latlong @trip
      @activity_detail = nil
      
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = "Trip activity not found"
      redirect_to :controller => 'trips', :action => 'index'
      return
    end
    respond_to do |format|
      case @trip_activity.activity_type
        when "LocationActivity"
          @activity.image_urls = (params[:selected_images].blank?) ? @activity.image_urls : params[:selected_images] 
          @activity.description = params[:description]
          @activity.duration = params[:duration]
          @activity.quick_tip = params[:quick_tip]
        when "TransportActivity"
          
        when "FoodActivity"
          @activity.image_urls = (params[:selected_images].blank?) ? @activity.image_urls : params[:selected_images] 
          @activity.description = params[:description]
          @activity.duration = params[:duration]
          @activity.quick_tip = params[:quick_tip]
      end
      
      if !(@activity and @activity.save)
        format.js
      else
        if @trip_activity.update_attributes(params[:trip_activity])
          @status = 1
          flash.now[:success] = "Successfully updated trip activity." 
          format.js
        else
          format.js
        end
      end
    end
  end
  
  # GET /publish_trip_activity_new
  # GET /publish_trip_activity_new.json
  def publish_trip_activity_new
    begin
      @update = 0
      @trip_activity = @trip.trip_activities.new
      if params[:day]
        @trip_activity.activity_day = params[:day]
      end
      
      @sequence = @trip_activity.max_sequence_activity_time_type(@trip_activity.activity_day)
      if !(@sequence.blank? or @sequence.first.blank?)
        @trip_activity.activity_time_type = @sequence.first.activity_time_type
      end 
      
      @activity = nil
      @activity_detail = nil
      @trip_activity.trip_id = params[:trip_id]
      @latlong = find_location_latlong @trip
      
      respond_to do |format|
        format.js
        format.html # publish_trip_activity_new.html.erb
        format.json { render json: @trip_activity }
      end   
    end
  end
  
  # POST /publish_trip_activity_create
  # POST /publish_trip_activity_create.json
  def publish_trip_activity_create
    begin
      @update = 0
      @status = 0
      @trip_activity = @trip.trip_activities.new(params[:trip_activity])
      
      @venue, error = FoursquareInteraction.venue_info(params[:venueid])
      @category = get_closest_category(@venue[:categories])
      @latlong = find_location_latlong(@trip)
      @activity = nil
      @activity_detail = nil
      @trip_activity.activity_type = @category
      @trip_activity.activity_sequence_number = 1
      @day = @trip_activity.max_sequence_number_day(@trip_activity.activity_day)
      if !@day.blank?
        @trip_activity.activity_sequence_number = @trip_activity.max_sequence_number_day(@trip_activity.activity_day).to_i + 1
      end
      
      case @category
        when "FoodActivity"
          logger.info " food activity \n"
          @activity = FoodActivity.new
          @activity.description = params[:description]
          @activity.duration = params[:duration]
          @activity.quick_tip = params[:quick_tip]
          @activity.image_urls = params[:selected_images]
          @activity.restaurant_detail_id = params[:venueid]
          @activity_detail = @activity.restaurant_detail
          if (@activity_detail.nil? or @activity_detail == 0)
            @activity_detail = create_food_venue(@venue[:id], params[:location_id], 0, @venue)
            @activity.restaurant_detail = @activity_detail
          end
        when "TransportActivity"
          logger.info " transport activity \n"
          @activity_detail = ""
          @activity = TransportActivity.new(params[:transport_activity])        
        else
          logger.info " location activity \n"
          @activity = LocationActivity.new
          @activity.description = params[:description]
          @activity.duration = params[:duration]
          @activity.quick_tip = params[:quick_tip]
          @activity.image_urls = params[:selected_images]
          @activity.location_detail_id = params[:venueid]
          @activity_detail = @activity.location_detail
          if (@activity_detail.nil? or @activity_detail == 0)
            @activity_detail = create_location_venue(@venue[:id], params[:location_id], 0, @venue)
            @activity.location_detail = @activity_detail
        end
      end
      
      respond_to do |format|
        if @activity_detail == nil or @activity_detail.errors.any?
          if @activity_detail.nil?
          else
            logger.info "activity detail errors #{@activity_detail.inspect.errors} "
          end
          format.js
          format.html { redirect_to new_trip_trip_activity_path(@trip), notice: 'Error during activity creation, retry.'  }
          format.json { render json: @activity_detail.errors, status: :unprocessable_entity }    
        else
          if !(@activity and @activity.save)
            logger.info "\n activity errors #{@activity.errors.messages} "
            format.js
            format.html { redirect_to new_trip_trip_activity_path(@trip), notice: @activity.errors.full_messages.to_sentence }
            format.json { render json: @activity.errors, status: :unprocessable_entity }    
          else        
            if params[:self_trip_activity_photos] != nil
             @photo = @trip_activity.self_trip_activity_photos.new(params[:self_trip_activity_photos])
             if @photo.save
               format.html {  redirect_to trip_trip_activities_path(@trip), notice: 'Trip photo was successfully added.' }
               format.json { render json: @trip_activity, status: :created, location: @trip_activity }
             else
               @activity.destroy # clean up
               format.js
               format.html {  redirect_to trip_trip_activities_path(@trip), notice: @photo.errors.full_messages.to_sentence  }
               format.json { render json: @photo.errors, status: :unprocessable_entity }
             end
            else
              @trip_activity.activity = @activity
              if @trip_activity.save
                @status = 1
                format.js 
                flash.now[:success] = "Successfully added new activity" 
                format.html { redirect_to trip_trip_activities_path(@trip), notice: 'Trip activity was successfully created.' }
                format.json { render json: @trip_activity, status: :created, location: @trip_activity }
              else
                logger.info "activity detail errors #{@trip_activity.errors.inspect}"
                @activity.destroy # clean up
                format.js
                format.html {  redirect_to trip_trip_activities_path(@trip), notice: @trip_activity.errors.full_messages.to_sentence  }
                format.json { render json: @trip_activity.errors, status: :unprocessable_entity }
              end
            end
          end
        end
      end     
    end
  end
  
  # DELETE /publish_trip_activity_destroy/1
  def publish_trip_activity_destroy
    begin
      @trip_activity = @trip.trip_activities.find(params[:id])
      @activity = @trip_activity.activity
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = "Trip activity not found"
      redirect_to :controller => 'trips', :action => 'index'
      return
    end
    
    @success_msg = "Trip Activity Removed Successfully!"
    respond_to do |format|
      @activity.destroy
      @trip_activity.destroy      
      format.js
      flash.now[:success] = @success_msg
      format.html { redirect_to @trip }
      format.json { head :no_content }        
    end
  end
  
  private
  
  def load_trip
    begin
      @trip = Trip.find(params[:trip_id])
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = "Trip not found"
      redirect_to :controller => 'trips', :action => 'index'
      return
    end
  end
  
  def use_https?
    #case params[:action]
    #when 
      
    #else
    #  false # Override in other controllers
    #end
    false
  end
end
