class UsersController < ApplicationController
	def show
		@user = User.friendly.find(params[:id])
		@twitterLink = "http://twitter.com/" + @user.username
		
		@contents = Content.where(:author => @user.id).page(params[:page]).per(5)
		@projects = Project.where(:author => @user.id).page(params[:page]).per(5)

		@new_project = Project.new 
		
		# THIS IS FOR THE DISPLAY MAP
		@geojson = Array.new

		# PUT CONTENTS ON MAP
		if @contents.exists? 
			@contents.each do |content|
				if (content.kind == "twitter")
					marker_color = '#4099FF'
				else 
					marker_color = '#FFCC00'
				end

				if (content.longitude != '0.0' || content.latitude != '0.0') && (content.longitude != '' || content.latitude != '')
				  @geojson << {
				    type: 'Feature',
				    geometry: {
				      type: 'Point',
				      coordinates: [content.longitude, content.latitude]
				    },
				    properties: {
				      name: content.title,
				      body: content.body, 
				      link: "/contents/" + content.id.to_s,
				      id: content.id,
				      address: 
					      if (content.city.present? && content.state.present?) 
					      	content.city + ", " + content.state
					      end,
				      :'marker-color' => marker_color,
				      :'marker-size' => 'small'
				    }
				  }
				end
			end
		end
		puts @geojson
		
		respond_to do |format|
		  format.html
		  format.json { render json: @geojson }  # respond with the created JSON object
		end	
	end
end
