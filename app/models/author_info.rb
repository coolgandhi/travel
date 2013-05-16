
class AuthorInfo < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  # attr_accessible :email, :password, :password_confirmation, :remember_me
  include Author_Validators
  attr_accessible :author_id, :address1, :address2, :address3, :author_name, :city, :state, :country, :email, :phone, :postal_code, :twitter_handle, :website, :about, :password, :password_confirmation, :remember_me, :birthday, :admin, :self_image, :self_image_tmp, :badge_level
  has_many :trips, :foreign_key => :author_id
  has_many :trip_stats
  #validates :author_name, :presence => { :message => "enter author name" }
  validates :email, :presence => { :message => "enter author email" }, :email => true
  validates_uniqueness_of :email, :message => "email already present"
  validates_length_of :about, :maximum => 200, :allow_blank => true
  
  mount_uploader :self_image, ImageUploader
  store_in_background :self_image
  
  def agg_author_views
    author_trip_stats = self.trip_stats
    agg_author_view_count = 0
    unless author_trip_stats.blank?
      author_trip_stats.each { |trip|
        agg_author_view_count = agg_author_view_count + trip.trip_views            
      }
    end
    agg_author_view_count
  end

  def agg_author_usefuls
    author_trip_stats = self.trip_stats
    agg_author_usefuls = 0
    unless author_trip_stats.blank?
      author_trip_stats.each { |trip|
        agg_author_usefuls = agg_author_usefuls + trip.useful            
      }
    end
    agg_author_usefuls
  end

  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |author_info|
      author_info.provider = auth.provider
      author_info.uid = auth.uid
      author_info.author_name = auth.info.name
      author_info.email = auth.info.email
      author_info.birthday = Date.strptime(auth.extra.raw_info.birthday,'%m/%d/%Y')
      author_info.encrypted_password = auth.credentials.token
      author_info.password_expire_at = Time.at(auth.credentials.expires_at)
      author_info.save!
    end
  end
  
  def self.new_with_session(params, session)
    if session["devise.author_info_attributes"]
      new(session["devise.author_info_attributes"], :without_protection => true) do |author_info|
        author_info.attributes = params
        author_info.valid?
      end
    else
      super
    end
  end
  
  def password_required?
    super && provider.blank?
  end
  
  def update_with_password(params, *options)
    if encrypted_password.blank?
      update_attributes(params, *options)
    else
      super
    end
  end
end
