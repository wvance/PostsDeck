class WelcomeController < ApplicationController
  def index
  	@all_users = User.all.to_a
  end
end
