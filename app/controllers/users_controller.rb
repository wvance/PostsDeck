class UsersController < ApplicationController
	def show
		@user = User.friendly.find(params[:id])
		@twitterLink = "http://twitter.com/" + @user.username
		
		@contents = Content.order('contents.created DESC').where(:author => @user.id).page(params[:page]).per(6)
		@projects = Project.order("position").where(:author => @user.id).page(params[:page]).per(5)
			
		@new_project = Project.new 
		
		# THIS IS FOR THE DISPLAY MAP
		@geojson = Array.new

		# PUT CONTENTS ON MAP
		if @contents.exists? 
			@contents.each do |content|
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
end
