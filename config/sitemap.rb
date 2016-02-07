# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "http://www.example.com"

SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'daily',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #

  users = User.all

  users.each do |user|
    subdomain = user.subdomain
    SitemapGenerator::Sitemap.default_host = "https://#{subdomain}.postsdeck.com"
    SitemapGenerator::Sitemap.sitemaps_path = "sitemaps/#{subdomain}"
    SitemapGenerator::Sitemap.create do
      content = Content.where(:author => user.id)
      content.each do |blog_post|
        add content_path(blog_post), :lastmod => blog_post.updated_at
      end
    end
  end

  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end
end
