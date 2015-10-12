class UsersController < ApplicationController
	def show
		# GET USER ID FROM SUBDOMAIN
		@user = User.find_by_subdomain!(request.subdomain)

		# GETS USER CONTENT
		@userContent = Content.order('contents.created DESC').where(:author => @user.id)

		# GET USER PROJECTS
		@userProject = Project.order("position").where(:author => @user.id)

		# COUNTS NUMBER OF TWEETS FROM USER
		@userTweetCount = @userContent.where(:kind => "twitter").count
		@posts = @user.number_statuses - @userTweetCount

		# raise @posts.inspect
		unless @posts == 0
			post_multiple_tweets(@@twitter_client, @posts)
		end

		@contents = @userContent.page(params[:page]).per(8)
		@projects = @userProject.page(params[:page]).per(5)
		@twitterLink = "http://twitter.com/" + @user.username


		# GET ALL CONTENT OBJECTS FOR THE MAP DISPLAY
		@mapContent = @userContent.where(:is_active => "true")
		@new_project = Project.new

		# THIS IS FOR THE DISPLAY MAP
		@geojson = Array.new

		# PUT CONTENTS ON MAP
		if @mapContent.exists?
			@mapContent.each do |content|
				puts "CONTENT KIND HERE :"
				puts content.kind
				if (content.kind == "twitter")
					marker_color = '#4099FF'
				else
					marker_color = '#FFCC00'
				end

				unless (content.longitude.nil? || content.latitude.nil?) || (content.longitude == '0' || content.latitude == '0')
				  @geojson << {
				    type: 'Feature',
				    geometry: {
				      type: 'Point',
				      coordinates: [
				      	content.longitude,
				      	content.latitude
				      ]
				    },
				    properties: {
				      name: content.title,
				      body: content.body,
				      link: "/contents/" + content.id.to_s,
				      id: content.id,
				      address:
					      if (content.city.present? && content.state.present?)
					      	content.city + ", " + content.state
					      elsif content.location.present?
					      	content.location
					      end,
				      :'marker-color' => marker_color,
				      :'marker-size' => 'small'
				    }
				  }
				end
			end
		end
		puts "START MAP OBJECT: "
		puts @geojson
		puts "END MAP OBJECT: "

		respond_to do |format|
		  format.html
		  format.json { render json: @geojson }  # respond with the created JSON object
		  # format.js
		end
	end

	private
    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:username)
    end
end
