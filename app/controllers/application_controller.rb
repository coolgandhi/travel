class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :miniprofiler
  before_filter :https_redirect
  
  
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

  
  def after_sign_in_path_for(resource)
     request.env['omniauth.origin'] || stored_location_for(resource) || author_page_author_info_url(current_author_info.id, :protocol => (Rails.env.production? and CONFIG[:ENABLE_HTTPS] == "yes")  ? "https": "http")
   end
   
  helper_method :admin?

  protected

  def admin?
    # if Rails.env.development?
    #   return true
    # else
      bret = session[:password] == "chal0iorocks" 
      bret = (true == bret)? bret : (!current_author_info.blank? and current_author_info.admin == true)
      return bret
    # end
  end

  def authorize
    unless admin?
      flash[:error] = "unauthorized access"
      redirect_to :controller => 'trips', :action => 'index'
      false
    end
  end
  
  private
  def https_redirect
    $request = request
    if CONFIG[:ENABLE_HTTPS] == "yes" and Rails.env.production?
      if request.ssl? && !use_https? || !request.ssl? && use_https?
        protocol = request.ssl? ? "http" : "https"
        flash.keep
        redirect_to protocol: "#{protocol}://", status: :moved_permanently
      end
    end
  end

  def use_https?
    true # Override in other controllers
  end
  
  def render_error(status, exception)

    logger.info "System Error: Tried to access '#{request.fullpath}'.\n#{exception.class} error was raised for path .\n#{exception.message} status: #{status} exception: #{exception}"
    ExceptionNotifier::Notifier.exception_notification(request.env, exception,
        :data => {:message => "chalo.io error: please check"}).deliver
  
    respond_to do |format|
      format.html { render template: "errors/error_#{status}", layout: 'layouts/application', status: status }
      format.all { render nothing: true, status: status }
    end
  end
  
  def miniprofiler
    Rack::MiniProfiler.authorize_request if admin?
  end
  
end
