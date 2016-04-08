namespace :delete do
  desc "Deletes all content in database"
  task :content => :environment do
    Comment.delete_all
    Content.delete_all
  end
end
