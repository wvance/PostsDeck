json.array!(@comments) do |comment|
  json.extract! comment, :id, :author, :body, :content, :parent_comment, :score
  json.url comment_url(comment, format: :json)
end
