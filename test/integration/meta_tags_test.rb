require "test_helper"

class MetaTagsTest < ActionDispatch::IntegrationTest
  setup do
    @post = posts(:one)
    @post.update!(status: :published, title: "Morning run by the sea", body: "<p>Ten kilometers before breakfast, and the sea was <strong>perfectly</strong> calm.</p>")
  end

  test "home page has the site title, description and link preview tags" do
    get root_path(utm_source: "instagram")

    assert_select "html[lang=en]"
    assert_select "title", "Butter & Stars"
    assert_select "meta[name=description][content=?]", MetaTagsHelper::SITE_DESCRIPTION
    assert_select "link[rel=canonical][href=?]", "http://www.example.com/"
    assert_select "meta[property='og:type'][content=website]"
    assert_select "meta[property='og:image'][content^='http://www.example.com/assets/butter-front_page']"
  end

  test "post page uses the post's title and text" do
    get post_path(@post)

    assert_select "title", "Morning run by the sea · Butter & Stars"
    assert_select "meta[name=description][content=?]", "Ten kilometers before breakfast, and the sea was perfectly calm."
    assert_select "meta[property='og:title'][content=?]", "Morning run by the sea"
    assert_select "meta[property='og:type'][content=article]"
    assert_select "link[rel=canonical][href=?]", post_url(@post)

    data = JSON.parse(css_select("script[type='application/ld+json']").first.text)
    assert_equal "BlogPosting", data["@type"]
    assert_equal "Morning run by the sea", data["headline"]
  end

  test "post page uses the post's image for link previews" do
    @post.images.attach(io: file_fixture("photo.png").open, filename: "photo.png", content_type: "image/png")
    get post_path(@post)

    assert_select "meta[property='og:image'][content*='/rails/active_storage/blobs/'][content$='photo.png']"
  end

  test "sitemap lists published posts only" do
    draft = posts(:two)
    draft.update!(status: :draft)

    get sitemap_path
    assert_response :success
    assert_equal "application/xml", response.media_type

    assert_includes response.body, "<loc>#{post_url(@post)}</loc>"
    assert_not_includes response.body, post_url(draft)
    assert_includes response.body, "<loc>#{blog_url}</loc>"
  end
end
