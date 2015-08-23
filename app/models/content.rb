class Content < ActiveRecord::Base
	extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  # Try building a slug based on the following fields in
  # increasing order of specificity.
  def slug_candidates
    [
      :title,
      [:title, :author],
      [:title, :author, :state],
      [:title, :author, :state, :city],
      [:title, :author, :state, :city, :id]
    ]
  end

  def should_generate_new_friendly_id?
  	new_record?
  end

	belongs_to :user

	# GEO INFO
	geocoded_by :ip, :latitude => :latitude, :longitude => :longitude

	geocoded_by :location ,
	  :latitude => :Latitude, :longitude => :Longitude	

	reverse_geocoded_by :latitude, :longitude do |obj,results|
	  if geo = results.first
	  	# FULL ADDRESS
	  	obj.address = geo.address 
	  	# CITY, STATE, COUNTRY & POSTAL CODE SEPERATE
	    obj.city = geo.city
	    obj.state = geo.state_code
	    obj.country = geo.country_code
	    obj.postal = geo.postal_code
	  end
	end

	after_validation :geocode, :reverse_geocode

end
