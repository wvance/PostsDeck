json.array!(@content_attachments) do |content_attachment|
  json.extract! content_attachment, :id, :content_id, :image, :created
  json.url content_attachment_url(content_attachment, format: :json)
end
