class DeviseRegistrationsCallbacksController < Devise::RegistrationsController

  protected
    def after_update_path_for(resource)
      flash[:notice] = "Author info was successfully updated."
      author_page_author_info_path(resource) 
    end
end