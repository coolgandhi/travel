
class AuthorInfo < ActiveRecord::Base
  include Author_Validators
  attr_accessible :author_id, :address1, :address2, :address3, :author_name, :bithday, :city, :country, :email, :phone, :postal_code, :twitter_handle, :website
  has_many :trips, :dependent => :destroy
  validates :author_name, :presence => { :message => "enter author name" }
  validates :email, :presence => { :message => "enter author email" }, :email => true
end
