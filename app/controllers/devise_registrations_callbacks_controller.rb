class DeviseRegistrationsCallbacksController < Devise::RegistrationsController

  protected
    def after_update_path_for(resource)
      flash[:notice] = "Author info was successfully updated."
      if !session[:return_to].blank?
        session.delete(:return_to)
      else  
        author_page_author_info_path(resource) 
      end
    end
end