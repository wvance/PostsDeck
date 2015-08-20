class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable
  validates :username, presence: true, uniqueness:true
  require 'json'
  
  def self.from_omniauth(auth)
  	twitterUser = where(provider: auth.provider, uid: auth.uid).first_or_create.tap do |user|
      puts JSON.pretty_generate(auth)
  		user.provider = auth.provider
  		user.uid = auth.uid
  		user.username = auth.info.nickname
  		user.location = auth.info.location
  		user.full_name = auth.info.name 
  		user.twitter_avatar = auth.info.image
  		user.bio = auth.info.description
      user.rating = auth.extra.raw_info.favourites_count
      user.number_followers = auth.extra.raw_info.followers_count
      user.number_statuses = auth.extra.raw_info.statuses_count
  	end
  end

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
  	super && provider.blank?
	end

end