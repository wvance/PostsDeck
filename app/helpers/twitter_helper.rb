require "twitter"
module TwitterHelper
  def user_timeline(qt)
    @@twitter.user_timeline(count: qt)
  end
end