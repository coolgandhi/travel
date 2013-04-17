class ErrorsController < ApplicationController
  def error_404
    @not_found_path = params[:not_found]
  end

  def error_500
  end
  
  private
  
  def use_https?
    false # Override in other controllers
  end
end
