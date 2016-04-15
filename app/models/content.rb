include ActionView::Helpers::SanitizeHelper

class Content < ActiveRecord::Base
	belongs_to :user
	has_many :comments, dependent: :delete_all
  has_many :content_attachments

	validates :external_id, uniqueness: true , :allow_blank => true, :allow_nil => true
	validates_presence_of :publish_at
	acts_as_taggable
	extend FriendlyId
  friendly_id :slug_candidates, use: :slugged
  is_impressionable

  after_save :update_words!

  def slug_candidates
  	[
  		 :title,
		  [:title, :author],
		  [:title, :author, :location],
		  [:title, :author, :location, :city, :state, :postal, :location]
		]
	end


	def word_count
    self.body.split.size
	end

	def reading_time
    (word_count / 180.0).ceil
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


	# USED FOR TFIDF
	def update_words!
		require 'htmlentities'; require'nokogiri'
		doc = Nokogiri::HTML.parse(body)

		doc.xpath("//pre").remove.xpath("//code").remove

		words = doc.text.gsub(/\n/, '').downcase
		words = HTMLEntities.new.decode(sanitize(words, :tags => []))
		words = words.split(/\W+/).reject(&:blank?).sort.join(',')
		words.gsub(/[^a-z\,]/i, '').split(',').reject(&:blank?).sort.join(',')
		update_columns(:words => words)
	end

	def update_related!
    contents = Content.all; related = {}
    idf = inverse_document_frequency(contents)

    (contents.select(&:is_active?) - [self]).each do |content|
      score = 0
      if content.words.present? && self.words.present?
        intersection = self.words.split(',').multiset(content.words.split(','))
        intersection.each { |word| score += idf[word]}
      end

      related[content.id] = score
    end

    related = related.sort_by {|k,v| v}.reverse
    related = related.collect {|k,v| k}.first(3).join(',')
    update_columns(:related_contents => related)
  end

	def related
    if related_contents.present?
		  Content.where(:kind =>"post").where(:id => related_contents.split(','))
    end
	end

	private
		def inverse_document_frequency(contents)
			words = {}
	    contents.each do |content|
	      if content.words.present?
	        text = content.words
	        text.split(',').uniq.each do |word|
	          words[word] = 0 if words[word].nil?
	          words[word] += 1
	        end
	      end
	    end

	    words.each do |word, freq|
	      words[word] = Math.log(contents.size / freq)
	    end
	    words
		end
end
