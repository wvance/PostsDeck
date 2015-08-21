json.array!(@projects) do |project|
  json.extract! project, :id, :author, :title, :link, :body, :github_link, :project_link, :start, :end, :location, :created, :edited
  json.url project_url(project, format: :json)
end
