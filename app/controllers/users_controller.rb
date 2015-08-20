class UsersController < ApplicationController
	def show
		@user = User.friendly.find(params[:id])
		@twitterLink = "http://twitter.com/" + @user.username
	end
end
