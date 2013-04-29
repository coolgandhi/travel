class AuthorInfoController < ApplicationController
  before_filter :authenticate_author_info!, :except => [:author_page]
  
  def about_edit
    @author_info = AuthorInfo.find(current_author_info.id);

    respond_to do |format|
      format.html # about_edit.html.erb
    end    
  end

  def about_update
    @author_info = AuthorInfo.find(current_author_info.id);

    respond_to do |format|
      if @author_info.update_attributes(params[:author_info])
        flash[:notice] = "Author info was successfully updated."
        format.html # about_update.html.erb
      else
        format.html { render :action => "publish_new" }
      end
    end
  end

  def author_page
    @use_id = current_author_info.id
    if params[:id] 
      @use_id = params[:id]
    end
    @author_info = AuthorInfo.find(@use_id);
    @trips_all = @author_info.trips
    @trips = @trips_all.where("share_status = ?", 1)
    @trips_unpublished = @trips_all.where("share_status = ?", 0)
    
    respond_to do |format|
      format.html # about_edit.html.erb
    end        
  end
  
  
  private
  
  def use_https?
    false # Override in other controllers
  end
end
