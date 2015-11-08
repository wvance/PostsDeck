class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
	# before_action :set_twitter_client


private
  def load_user
    # @user = User.find_by_subdomain!(request.subdomain)
  end

  def set_twitter_client
    if user_signed_in?
      @@twitter_client ||= Twitter::REST::Client.new do |config|
	      config.consumer_key = ENV['twitter_consumer_key']
	      config.consumer_secret = ENV['twitter_consumer_secret']
	      config.access_token = current_user.user_provider.where(:provider => "twitter").first.token
	      config.access_token_secret = current_user.user_provider.where(:provider => "twitter").first.secret
	    end
    end
  end

  def set_foursquare_client
    client = Foursquare2::Client.new(:oauth_token => current_user.user_provider.where(:provider => "foursquare").first.token)
  end

  def user_timeline(user_client, qt)
    user_client.user_timeline(count: qt)
  end

  def geoSearch(user_client, location)
    user_client.geo_search(query: location)
    # raise user_client.geo_search(query: location).inspect
  end

  def post_multiple_tweets(user_client, count)
    # GET A USER'S TIMELINE GOING BACK AS FAR AS COUNT
    user_tweets = user_client.user_timeline(count: count)

    # LOOP THROUGH EACH TWEET IN USER TIMELINE AND CREATE 'NEW CONTENT'
    user_tweets.each do |tweet|
      new_tweet = Content.new
      new_tweet.title = tweet.text.truncate(30, separator: ' ')
      new_tweet.external_id = tweet.id
      new_tweet.body = tweet.text
      new_tweet.author = @user.id
      new_tweet.kind = "twitter"
      new_tweet.external_link = tweet.url

      if tweet.created_at.present?
        new_tweet.created = tweet.created_at
      else
        new_tweet.created = DateTime.now
      end
      new_tweet.updated = DateTime.now

      if tweet.media.present?
        new_tweet.image = tweet.media[0].media_url
      end

      new_tweet.longitude = tweet.place.bounding_box.coordinates[0][0][0]
      new_tweet.latitude = tweet.place.bounding_box.coordinates[0][0][1]

      if tweet.place.present?
        new_tweet.location = tweet.place.full_name

        # GEO SEARCH: COMMENTED OUT FOR NOW... CANT FIGURE OUT HASH PARSING

        # raise geo_result = geoSearch(user_client, tweet.place.full_name).inspect
        # new_tweet.longitude = geo_result.centroid
        # raise geo_result.centroid.inspect
      end

      new_tweet.has_comments = true
      new_tweet.is_active = true

      if new_tweet.valid?
        new_tweet.save!
      end
    end
  end
  # def send_tweet(title, link)
  # 	@@twitter_client.update(title + " : " + link)
  # end
end
