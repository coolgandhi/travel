
class AuthorInfo < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  # attr_accessible :email, :password, :password_confirmation, :remember_me
  include Author_Validators
  attr_accessible :author_id, :address1, :address2, :address3, :author_name, :bithday, :city, :state, :country, :email, :phone, :postal_code, :twitter_handle, :website, :about, :password, :password_confirmation, :remember_me
  has_many :trips, :dependent => :destroy
  validates :author_name, :presence => { :message => "enter author name" }
  validates :email, :presence => { :message => "enter author email" }, :email => true
  validates_uniqueness_of :email, :message => "email already present"
  validates_length_of :about, :maximum => 200, :allow_blank => true
end
