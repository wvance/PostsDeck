class WelcomeController < ApplicationController
  def index
  	@all_users = User.all 
  end
end
