
class AuthorInfo < ActiveRecord::Base
  include Author_Validators
  attr_accessible :author_id, :address1, :address2, :address3, :author_name, :bithday, :city, :state, :country, :email, :phone, :postal_code, :twitter_handle, :website, :blurb
  has_many :trips, :dependent => :destroy
  validates :author_name, :presence => { :message => "enter author name" }
  validates :email, :presence => { :message => "enter author email" }, :email => true
  validates_uniqueness_of :email, :message => "email already present"
  validates_length_of :blurb, :maximum => 200, :allow_blank => true
end
