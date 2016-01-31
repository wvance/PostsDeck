class UserProvider < ActiveRecord::Base
  belongs_to :user

  # http://jorge.caballeromurillo.com/multiple-omniauth-providers-for-same-user-on-ruby-on-rails/
  # def self.find_for_facebook_oauth(auth)

  #   user = UserProvider.where(:provider => auth.provider, :uid => auth.uid).first
  #   unless user.nil?
  #     user.user
  #   else
  #     registered_user = User.where(:email => auth.info.email).first
  #     unless registered_user.nil?
  #       UserProvider.create!(
  #         provider: auth.provider,
  #         uid: auth.uid,
  #         user_id: registered_user.id
  #         )
  #       registered_user
  #     else
  #       user = User.create!(
  #         first_name: auth.info.name,
  #         email: auth.info.email,
  #         password: Devise.friendly_token[0,20],
  #       )
  #       user_provider = UserProvider.create!(
  #         provider:auth.provider,
  #         uid:auth.uid,
  #         user_id: user.id,
  #         token: auth.credentials.token,
  #         secret: auth.credentials.secret
  #       )
  #       user
  #     end
  #   end
  # end

  # def self.find_for_foursquare_oauth(auth)
  #   user = UserProvider.where(:provider => auth.provider, :uid => auth.uid).first
  #   # raise auth.inspect
  #   unless user.nil?
  #     user.user
  #   else
  #     registered_user = User.where(:email => auth.info.email).first
  #     unless registered_user.nil?
  #       UserProvider.create!(
  #         provider: auth.provider,
  #         uid: auth.uid,
  #         user_id: registered_user.id
  #       )
  #     registered_user
  #     else
  #       # raise auth.inspect
  #       username = auth.info.first_name + auth.info.last_name
  #       avatar = auth.info.image[:prefix] + "256x256" + auth.info.image[:suffix]
  #       subdomain = username.downcase

  #       user = User.create!(
  #         first_name: auth.info.name,
  #         email: auth.info.email,
  #         password: Devise.friendly_token[0,20],
  #         username: username,
  #         subdomain: subdomain,
  #         first_name: auth.info.first_name,
  #         last_name: auth.info.last_name,
  #         full_name: auth.info.name,
  #         avatar: avatar
  #       )
  #       user_provider = UserProvider.create!(
  #         provider:auth.provider,
  #         uid:auth.uid,
  #         user_id: user.id,
  #         token: auth.credentials.token,
  #         secret: auth.credentials.secret
  #       )
  #       user
  #     end
  #   end
  # end

  # def self.find_for_google_oauth(auth)
  #   user = UserProvider.where(:provider => auth.provider, :uid => auth.uid).first
  #   unless user.nil?
  #     user.user
  #   else
  #     registered_user = User.where(:email => auth.info.email).first
  #     unless registered_user.nil?
  #       UserProvider.create!(
  #         provider: auth.provider,
  #         uid: auth.uid,
  #         user_id: registered_user.id
  #       )
  #     registered_user
  #     else
  #       user = User.create!(
  #         first_name: auth.info.name,
  #         email: auth.info.email,
  #         password: Devise.friendly_token[0,20],
  #       )
  #       user_provider = UserProvider.create!(
  #         provider:auth.provider,
  #         uid:auth.uid,
  #         user_id: user.id,
  #         token: auth.credentials.token,
  #         secret: auth.credentials.secret
  #       )
  #       user
  #     end
  #   end
  # end

  def self.find_for_twitter_oauth(auth)
    user = UserProvider.where(:provider => auth.provider, :uid => auth.uid).first

    # Auth here is full
    unless user.nil?
      avatar = auth.info.image
      avatar.slice! "_normal"

      user.user.update(
        avatar: avatar,
        twitter_avatar: avatar,

        # NORMALIZE NAME
        full_name: auth.info.name,
        first_name: auth.info.name.split[0],
        last_name: auth.info.name.split[1],

        location: auth.info.location,
        bio: auth.info.description,
        rating: auth.extra.raw_info.favourites_count,
        number_followers: auth.extra.raw_info.followers_count,
        number_statuses: auth.extra.raw_info.statuses_count
        )
      user.user
      # raise user.user.inspect
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
          password: Devise.friendly_token[0,20],
          username: auth.info.nickname,
          subdomain: auth.info.nickname.downcase,  #NOTE: THIS MUST COME AFTER USER.USERNAME ASSIGNMENT
          location: auth.info.location,

          # NORMALIZE NAME
          full_name: auth.info.name,
          first_name: auth.info.name.split[0],
          last_name: auth.info.name.split[1],

          # NORMALIZE IMAGE

          avatar: avatar,
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
        demo_project = Project.create!(
          author:user.id,
          title: "Demo Project!",
          image:"https://s3.amazonaws.com/wesleyvance/assets/social/BlackBoxLogo.png",
          body:"This is a demo project! Share a hobby, resume or whatever you'd like! Get started by signing into your account and selecting 'New Project'!",
          position:0,
          github_link: "http://github.com",
          project_link: "http://blackboxapp.io"
          # datetime: DateTime.now,
        )

        # if cookies[:lat_lng] != nil
        #   @lat_lng = cookies[:lat_lng].split("|")
        # else
          @ip = $request.remote_ip
        # end
          # raise @ip.inspect

        demo_post = Content.create!(
          author:user.id,
          title:"Welcome Post!",
          kind:"post",
          has_comments: "t",
          # datetime: DateTime.now,
          body:"Welcome to BlackBox! You're life collected.",
          # latitude: @lat_lng[0],
          # longitude: @lat_lng[1],
          ip: @ip
        )
        demo_comment = Comment.create!(
          content_id:demo_post.id,
          body: "This is a demo comment on your demo post! Yay :D. Comment on others posts!",
          email: "Test@demo.com",
          # datetime: DateTime.now
        )
        user
      end
    end
  end
end
