class ErrorsController < ApplicationController
  def error_404
    @not_found_path = params[:not_found]
    if !@not_found_path.blank? and @not_found_path.include? "apple-touch"
      respond_to do |format|
        format.png { render :nothing => true, :status => 404 }
      end
    end
  end

  def error_500
  end
  
  private
  
  def use_https?
    false # Override in other controllers
  end
end
