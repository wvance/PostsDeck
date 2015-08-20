class UsersController < ApplicationController
	def show
		@user = User.find(params[:id])
		@twitterLink = "http://twitter.com/" + @user.username
	end
end
