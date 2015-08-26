class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
	before_action :set_twitter_client

  private

  def set_twitter_client
    if user_signed_in?
      @@twitter_client ||= Twitter::REST::Client.new do |config|
	      config.consumer_key = ENV['twitter_consumer_key']
	      config.consumer_secret = ENV['twitter_consumer_secret']
	      config.access_token = current_user.token
	      config.access_token_secret = current_user.secret
	    end
    end
  end
  
  def user_timeline(user_client, qt)
    user_client.user_timeline(count: qt)
  end

  def post_multiple_tweets(user_client, count)
    # GET A USER'S TIMELINE
    user_tweets = user_client.user_timeline(count: count)

    # LOOP THROUGH EACH TWEET IN USER TIMELINE AND CREATE 'NEW CONTENT'
    user_tweets.each do |tweet|
      new_tweet = Content.new
      new_tweet.title = tweet.text.truncate(30, separator: ' ')
      new_tweet.external_id = tweet.id
      new_tweet.body = tweet.text
      new_tweet.author = current_user.id
      new_tweet.external_link = tweet.url

      if tweet.media.present?
        new_tweet.image = tweet.media[0]["media_url"]
      end

      if tweet.place.full_name.present?
        new_tweet.location = tweet.place.full_name + ", " + tweet.place.country_code
      end

      new_tweet.created = DateTime.now
      new_tweet.updated = DateTime.now

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
