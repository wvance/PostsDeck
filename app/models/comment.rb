class Comment < ActiveRecord::Base
  belongs_to :content

  include Gravtastic
  gravtastic :default => "https://s3.amazonaws.com/wesleyvance/assets/social/default.jpg"

end
