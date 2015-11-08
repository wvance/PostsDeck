class UserProvider < ActiveRecord::Base
  belongs_to :user

  # http://jorge.caballeromurillo.com/multiple-omniauth-providers-for-same-user-on-ruby-on-rails/
  def self.find_for_facebook_oauth(auth)

    user = UserProvider.where(:provider => auth.provider, :uid => auth.uid).first
    unless user.nil?
      user.user
    else
      registered_user = User.where(:email => auth.info.email).first
      unless registered_user.nil?
        UserProvider.create!(
          provider: auth.provider,
          uid: auth.uid,
          user_id: registered_user.id
          )
        registered_user
      else
        user = User.create!(
          first_name: auth.info.name,
          email: auth.info.email,
          password: Devise.friendly_token[0,20],
        )
        user_provider = UserProvider.create!(
          provider:auth.provider,
          uid:auth.uid,
          user_id: user.id,
          token: auth.credentials.token,
          secret: auth.credentials.secret
        )
        user
      end
    end
  end

  def self.find_for_foursquare_oauth(auth)
    user = UserProvider.where(:provider => auth.provider, :uid => auth.uid).first
    unless user.nil?
      user.user
    else
      registered_user = User.where(:email => auth.info.email).first
      unless registered_user.nil?
        UserProvider.create!(
          provider: auth.provider,
          uid: auth.uid,
          user_id: registered_user.id
        )
      registered_user
      else
        user = User.create!(
          first_name: auth.info.name,
          email: auth.info.email,
          password: Devise.friendly_token[0,20],
        )
        user_provider = UserProvider.create!(
          provider:auth.provider,
          uid:auth.uid,
          user_id: user.id,
          token: auth.credentials.token,
          secret: auth.credentials.secret
        )
        user
      end
    end
  end

  def self.find_for_google_oauth(auth)
    user = UserProvider.where(:provider => auth.provider, :uid => auth.uid).first
    unless user.nil?
      user.user
    else
      registered_user = User.where(:email => auth.info.email).first
      unless registered_user.nil?
        UserProvider.create!(
          provider: auth.provider,
          uid: auth.uid,
          user_id: registered_user.id
        )
      registered_user
      else
        user = User.create!(
          first_name: auth.info.name,
          email: auth.info.email,
          password: Devise.friendly_token[0,20],
        )
        user_provider = UserProvider.create!(
          provider:auth.provider,
          uid:auth.uid,
          user_id: user.id,
          token: auth.credentials.token,
          secret: auth.credentials.secret
        )
        user
      end
    end
  end

  def self.find_for_twitter_oauth(auth)
    user = UserProvider.where(:provider => auth.provider, :uid => auth.uid).first
    unless user.nil?
      user.user
    else
      registered_user = User.where(:username => auth.info.nickname).first
      unless registered_user.nil?
        UserProvider.create!(
          provider: auth.provider,
          uid: auth.uid,
          user_id: registered_user.id
        )
       registered_user
      else
        avatar = auth.info.image
        avatar.slice! "_normal"

        user = User.create!(
          first_name: auth.extra.raw_info.name,
          username: auth.info.nickname,
          password: Devise.friendly_token[0,20],
          username: auth.info.nickname,
          subdomain: auth.info.nickname.downcase,  #NOTE: THIS MUST COME AFTER USER.USERNAME ASSIGNMENT
          location: auth.info.location,


          # NORMALIZE NAME
          full_name: auth.info.name,
          first_name: auth.info.name.split[0],
          last_name: auth.info.name.split[1],

          # NORMALIZE IMAGE

          twitter_avatar: avatar,

          bio: auth.info.description,
          rating: auth.extra.raw_info.favourites_count,
          number_followers: auth.extra.raw_info.followers_count,
          number_statuses: auth.extra.raw_info.statuses_count,
        )
        user_provider = UserProvider.create!(
          provider:auth.provider,
          uid:auth.uid,
          user_id: user.id,
          token: auth.credentials.token,
          secret: auth.credentials.secret
        )
        user
      end
    end
  end
end
