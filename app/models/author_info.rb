class AuthorInfo < ActiveRecord::Base
  attr_accessible :author_id, :address1, :address2, :address3, :author_name, :bithday, :city, :country, :email, :phone, :postal_code, :twitter_handle, :website
end
