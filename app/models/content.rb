class Content < ActiveRecord::Base
	belongs_to :user
	has_many :comments, dependent: :delete_all

	validates :external_id, uniqueness: true , :allow_blank => true, :allow_nil => true

	extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  def slug_candidates
  	[
  		 :title,
		  [:title, :author],
		  [:title, :author, :location],
		  [:title, :author, :location, :city, :state, :postal, :location]
		]
	end

  def should_generate_new_friendly_id?
    new_record?
  end

	# GEO INFO
	geocoded_by :ip, :latitude => :latitude, :longitude => :longitude

	geocoded_by :location ,
	  :latitude => :Latitude, :longitude => :Longitude

	reverse_geocoded_by :latitude, :longitude do |obj,results|
	  if geo = results.first
	  	# CITY, STATE, COUNTRY & POSTAL CODE SEPERATE
	    obj.city = geo.city
	    obj.state = geo.state_code
	    obj.country = geo.country_code
	    obj.postal = geo.postal_code

	  	# FULL ADDRESS
	  	if geo.address
	  		obj.address = geo.address
	  	else
	  		obj.address = geo.city + " " + geo.state_code + " " + geo.country_code + " " + geo.postal_code
	  		if obj.location.present?
	  			obj.location = obj.address
	  		end
	  	end
	  end
	end

	unless :latitude.present? && :longitude.present?
		after_validation :geocode
	end

	after_validation :reverse_geocode
end
