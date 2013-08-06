class DeviseRegistrationsCallbacksController < Devise::RegistrationsController

  protected
    def after_update_path_for(resource)
      flash[:notice] = "Author info was successfully updated."
      if !session[:return_to].blank?
        session.delete(:return_to)
      else  
        if !resource.author_handle.blank? 
          "/" + resource.author_handle
        else
          author_page_author_info_path(resource) 
        end
      end
    end
end