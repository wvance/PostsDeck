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
  
  def user_timeline(qt)
    @@twitter_client.user_timeline(count: qt)
  end

  # def send_tweet(title, link)
  # 	@@twitter_client.update(title + " : " + link)
  # end
end
