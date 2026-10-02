xml.instruct!
xml.urlset xmlns: "http://www.sitemaps.org/schemas/sitemap/0.9" do
  [ root_url, blog_url ].each do |url|
    xml.url { xml.loc url }
  end

  @posts.each do |post|
    xml.url do
      xml.loc post_url(post)
      xml.lastmod post.updated_at.to_date.iso8601
    end
  end
end
