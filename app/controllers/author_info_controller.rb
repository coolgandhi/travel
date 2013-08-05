class AuthorInfoController < ApplicationController
  include ApplicationHelper
  before_filter :authenticate_author_info!, :except => [:author_page]
  
  def about_edit
    @author_info = AuthorInfo.find(current_author_info.id)

    respond_to do |format|
      format.html # about_edit.html.erb
    end    
  end

  def about_update
    @author_info = AuthorInfo.find(current_author_info.id)

    respond_to do |format|
      if @author_info.update_attributes(params[:author_info])
        flash[:notice] = "Author info was successfully updated."
        format.html { redirect_to author_page_author_info_path(@author_info) }
      else
        format.html { render :action => "publish_edit" }
      end
    end
  end

  # author_page and author_page_given_userhandle
  def author_page
    @use_id = nil
    @user_handle = nil
    params[:not_found] = ""
    # if !current_author_info.blank?
    #   @use_id = current_author_info.id
    # end
    if params[:id] 
      @use_id = params[:id]
    end
    if params[:username] 
      @user_handle = params[:username]
      params[:not_found] = params[:username]  
    end
    
    respond_to do |format|
      if !@use_id.blank? or !@user_handle.blank?
        @author_info = !@use_id.blank? ? AuthorInfo.find(@use_id) : AuthorInfo.find_by_author_handle(@user_handle)
        if !@author_info.blank?
          @trips_all = @author_info.trips
          @trips = @trips_all.where("share_status = ?", 1)
        
        
          @useful_count = 0
          @trip_count = @trips.size 
          @trip_duration_count = 0
          @trip_activities_count = 0
          @trip_view_count = 0
        
          @trip_stats = @author_info.trip_stats
          if !@trip_stats.blank?
            @trip_stats.each { |trip_stat|
              @useful_count = @useful_count + trip_stat.useful
              @trip_duration_count = @trip_duration_count + trip_stat.trip_durations
              @trip_activities_count = @trip_activities_count + trip_stat.trip_activities
              @trip_view_count = @trip_view_count + trip_stat.trip_views            
            }
          end
          @trips_unpublished = @trips_all.where("share_status = ?", 0)
        
          message = ""
          # if @trips_unpublished.size > 0
          #   message = "We would love to see your private trips."          
          # end
    
          if !current_author_info.blank? and self.is_system_created_account current_author_info.email
            message = message + " #{view_context.link_to('Click here to update your email and password.', edit_author_info_registration_url(:protocol => (Rails.env.production? and CONFIG[:ENABLE_HTTPS] == "yes")  ? "https": "http"))}"
          end
        
          flash[:alert] = message.html_safe if message != ""
          format.html # about_edit.html.erb
        else
          @not_found_path = params[:not_found]
          raise ActionController::RoutingError.new("Not found")
        end
      else
        @not_found_path = params[:not_found]
        raise ActionController::RoutingError.new("Not found")
      end
    end        
  end
  
  
  private
  
  def use_https?
    use = false
    case action_name
      when "about_edit"
        use = true
      when "about_update"
        use = true
    end
    use
  end
end
