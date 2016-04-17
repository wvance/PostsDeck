class WelcomeController < ApplicationController
  def index
    @all_content = Content.all
  	@all_users = User.all.to_a
  end
end
