class UsersController < ApplicationController
	before_filter :set_user

	before_action :verify_is_owner, only: [:edit, :update]
	before_filter :get_user_content
	require 'sanitize'

	def edit

	end

	# PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'Profile was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end


	def show
		# COUNTS NUMBER OF TWEETS FROM USER
		@userTweetCount = @userTweet.count
		@posts = @user.number_statuses - @userTweetCount

		# CREATE NEW POSTS FROM ABOVE CALCULATIONS
		if user_signed_in?
			post_multiple_tweets(@@twitter_client, @posts)
		end

		if params[:tag]
			@contents = Content.tagged_with(params[:tag]).page(params[:page]).per(6)
		else
			@contents = @userBlog.page(params[:page]).per(15)
		end

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
				# puts "CONTENT KIND HERE :"
				# puts content.kind
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
		# puts "START MAP OBJECT: "
		# puts @geojson
		# puts "END MAP OBJECT: "

		respond_to do |format|
		  format.html
		  format.json { render json: @geojson }  # respond with the created JSON object
		  # format.js
		end
	end

	private
		def set_user
			# GET USER ID FROM SUBDOMAIN
			if request.subdomain.present?
				@user = User.friendly.find_by_subdomain!(request.subdomain)
			else
				@user = User.friendly.find_by_subdomain!('wesadvance')
			end
		end

		def verify_is_owner
      if (current_user == User.where(:id => @user.id).first)
        return
      else
        redirect_to(root_path)
      end
    end

		def get_user_content
			# GETS USER CONTENT
			@userContent = Content.order('is_sticky DESC, created_at DESC').where(:author => @user.id)
			@userBlog = @userContent.where(:kind =>"post")
			@userTweet = @userContent.where(:kind =>"twitter")
			# GET USER PROJECTS
			@userProject = Project.order("position").where(:author => @user.id)
		end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:username, :email, :bio, :avatar, :address, :street, :city, :postal, :first_name, :last_name)
    end
end
