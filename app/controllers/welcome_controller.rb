class WelcomeController < ApplicationController
  def index
    @active_content = Content.where(:kind => "post").where(:is_active => true).limit(6)

  	@all_users = User.all.to_a
  end

end
