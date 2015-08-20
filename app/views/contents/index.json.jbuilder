json.array!(@contents) do |content|
  json.extract! content, :id, :title, :author, :body, :image, :external_id, :external_link, :kind, :rating, :location, :address, :city, :state, :country, :postal, :ip, :latitude, :longitude, :is_active, :has_comments, :created, :updated
  json.url content_url(content, format: :json)
end
