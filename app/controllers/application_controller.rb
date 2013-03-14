class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :miniprofiler
  
  #session :session_key => '_chaloio_session_id'
  # added a customizable error message for unknown paths user access 
  # refer to http://ramblinglabs.com/blog/2012/01/rails-3-1-adding-custom-404-and-500-error-pages
  # Quote: "The errors are not shown on development, so to test them out and make sure that they work as expected, temporarily remove the Rails.application.config.consider_all_requests_local condition from both the config/routes.rb and the app/controllers/application_controller.rb files."
  # Change local requests to false from true. 'config.consider_all_requests_local = false'
  # in development.rb
  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception, with: lambda { |exception| render_error 500, exception }
    rescue_from ActionController::RoutingError, ActionController::UnknownController, ::AbstractController::ActionNotFound, ActiveRecord::RecordNotFound, with: lambda { |exception| render_error 404, exception }
  end

  helper_method :admin?

  protected

  def admin?
    if Rails.env.development?
      return true
    else
      return session[:password] == "foobar"
    end
  end

  def authorize
    unless admin?
      flash[:error] = "unauthorized access"
      redirect_to :controller => 'trips', :action => 'index'
      false
    end
  end
  
  private
  def render_error(status, exception)
    respond_to do |format|
      format.html { render template: "errors/error_#{status}", layout: 'layouts/application', status: status }
      format.all { render nothing: true, status: status }
    end
  end
  
  def miniprofiler
    Rack::MiniProfiler.authorize_request if admin?
  end
  
end
