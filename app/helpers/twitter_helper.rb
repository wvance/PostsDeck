require "twitter"
module TwitterHelper
	@@twitter = Twitter::REST::Client.new do |config|
	  config.consumer_key = ENV['twitter_consumer_key']
	  config.consumer_secret = ENV['twitter_consumer_secret']
	  config.access_token = ENV['twitter_access_token']
	  config.access_token_secret = ENV['twitter_access_secret']
	end

  def user_timeline(qt)
    @@twitter.user_timeline(count: qt)
  end
end