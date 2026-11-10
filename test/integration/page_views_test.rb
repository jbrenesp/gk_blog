require "test_helper"

class PageViewsTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  BROWSER = CookieConsentTest::BROWSER

  test "records a page view on the visit" do
    get root_path, headers: BROWSER
    visit = Ahoy::Visit.last

    assert_difference("Ahoy::Event.count", 1) do
      post page_views_path, params: { path: "/blog" }, headers: BROWSER, as: :json
    end
    assert_response :no_content

    event = Ahoy::Event.last
    assert_equal visit, event.visit
    assert_equal Ahoy::Event::PAGE_VIEW, event.name
    assert_equal "/blog", event.properties["path"]
    assert_includes Ahoy::Visit.with_page_views, visit
  end

  test "ignores page views without a visit" do
    assert_no_difference([ "Ahoy::Visit.count", "Ahoy::Event.count" ]) do
      post page_views_path, params: { path: "/" }, headers: BROWSER, as: :json
    end
    assert_response :no_content
  end

  test "ignores bots" do
    assert_no_difference([ "Ahoy::Visit.count", "Ahoy::Event.count" ]) do
      get root_path, headers: { "User-Agent" => "Googlebot/2.1 (+http://www.google.com/bot.html)" }
      post page_views_path, params: { path: "/" }, headers: { "User-Agent" => "Googlebot/2.1 (+http://www.google.com/bot.html)" }, as: :json
    end
  end

  test "ignores admins" do
    sign_in users(:one)

    assert_no_difference([ "Ahoy::Visit.count", "Ahoy::Event.count" ]) do
      get root_path, headers: BROWSER
      post page_views_path, params: { path: "/" }, headers: BROWSER, as: :json
    end
  end
end
