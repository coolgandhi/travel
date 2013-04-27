class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def all
    author_info = AuthorInfo.from_omniauth(request.env["omniauth.auth"])
    if author_info.persisted?
     flash.notice = "Signed in!"
     sign_in_and_redirect author_info
    else
     session["devise.author_info_attributes"] = author_info.attributes
     redirect_to new_author_info_registration_url
    end
  end
  
  alias_method :facebook, :all
  
end
