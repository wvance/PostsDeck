class User < ActiveRecord::Base
  extend FriendlyId
  friendly_id :username

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable

  devise :database_authenticatable, :registerable, :omniauthable,
     :recoverable, :rememberable, :trackable, :validatable,
     :omniauth_providers => [:facebook, :foursquare, :google_oauth2, :twitter]


  validates :username, presence: true, uniqueness:true

  has_many :contents
  has_many :projects
  has_many :user_provider, :dependent => :destroy

  require 'json'

  # def self.from_omniauth(auth)
  # 	twitterUser = where(provider: auth.provider, uid: auth.uid).first_or_create.tap do |user|
  #     puts JSON.pretty_generate(auth)
  # 		user.provider = auth.provider
  # 		user.uid = auth.uid
  #     user.token = auth.credentials.token
  #     user.secret = auth.credentials.secret

  # 		user.username = auth.info.nickname
  #     user.subdomain = user.username.downcase  #NOTE: THIS MUST COME AFTER USER.USERNAME ASSIGNMENT
  # 		user.location = auth.info.location

  #     # NORMALIZE NAME
  #     fullName = auth.info.name.split
  # 		user.full_name = auth.info.name
  #     user.first_name = fullName[0]
  #     user.last_name = fullName[1]

  #     # NORMALIZE IMAGE
  #     avatar = auth.info.image
  #     avatar.slice! "_normal"
  # 		user.twitter_avatar = avatar


  # 		user.bio = auth.info.description
  #     user.rating = auth.extra.raw_info.favourites_count
  #     user.number_followers = auth.extra.raw_info.followers_count
  #     user.number_statuses = auth.extra.raw_info.statuses_count
  # 	end
  # end

  def self.new_with_session(params, session)
  	if session["devise.user_attributes"]
  		new(session["devise.user_attributes"], without_protection: true) do |user|
  			user.attributes = params
  			user.valid?
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
  		update_attributes(params,*options)
  	else
  		super
  	end
 	end
  def email_required?
    false
  end

 # 	def email_required?
 #  	super && provider.blank?
	# end
end
