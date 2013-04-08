class SessionsController < ApplicationController
  def new
    respond_to do |format|
      format.html # new.html.erb
    end
  end
  
  def create
    #logger.info "#{params[:password]}"
    session[:password] = params[:password]
    flash[:notice] = "Successfully logged in"
    redirect_to root_path
  end

  def del
    reset_session
    flash[:notice] = "Successfully logged out"
    redirect_to root_path
  end
end
