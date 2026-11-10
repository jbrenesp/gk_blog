require "test_helper"

class Admin::DashboardControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @post = posts(:one)
    @post.update!(title: "Butter tips", status: :published, views_count: 42)

    visit(landing_page: "http://www.example.com/posts/#{@post.id}?fbclid=abc", referring_domain: "instagram.com", device_type: "Mobile", browser: "Safari")
    visit(landing_page: "http://www.example.com/posts/#{@post.id}", referring_domain: "www.google.com", device_type: "Mobile", browser: "Chrome")
    visit(landing_page: "http://www.example.com/blog", referring_domain: "example.com", device_type: "Desktop", browser: "Chrome")
    visit(landing_page: "http://www.example.com/", device_type: nil, browser: "Chrome", started_at: 3.days.ago)
    visit(landing_page: "http://www.example.com/", started_at: 45.days.ago)
  end

  test "shows visit analytics to admins" do
    sign_in users(:one)
    get admin_dashboard_path
    assert_response :success

    assert_select ".visits-chart-col", 30
    assert_select ".visits-chart-table tbody tr", 30

    # post pages show the post title, query strings are ignored
    assert_select ".ranked-list-label a[href=?]", post_path(@post), text: "Butter tips"
    assert_select ".ranked-list-label a[href=?]", blog_path, text: "Blog"
    assert_select ".ranked-list-label a[href=?]", root_path, text: "Home page"

    # the site's own domain isn't an external referrer
    assert_select ".ranked-list-label", text: "instagram.com"
    assert_select ".ranked-list-label", text: "www.google.com"
    assert_select ".ranked-list-label", text: "example.com", count: 0
    assert_select ".ranked-list-label", text: "Direct / no referrer"

    assert_select ".ranked-list-label", text: "Mobile"
    assert_select ".ranked-list-label", text: "Unknown"
    assert_select ".ranked-list-label", text: "Chrome"
  end

  test "only counts visits with a page view" do
    visit(landing_page: "http://www.example.com/?rest_route=/batch/v1", referring_domain: "spam.example", browser: "Bot Browser", page_view: false)
    sign_in users(:one)
    get admin_dashboard_path

    assert_select ".dashboard-card", text: /Site Visits \(Total\)\s*5/
    assert_select ".ranked-list-label", text: "spam.example", count: 0
    assert_select ".ranked-list-label", text: "Bot Browser", count: 0
  end

  test "counts post views from real browsers, once per visit" do
    reader = visit
    2.times { reader.events.create!(name: Ahoy::Event::PAGE_VIEW, properties: { path: "/posts/#{@post.id}" }, time: Time.current) }
    visit.events.create!(name: Ahoy::Event::PAGE_VIEW, properties: { path: "/posts/#{@post.id}" }, time: Time.current)
    visit.events.create!(name: Ahoy::Event::PAGE_VIEW, properties: { path: "/blog" }, time: Time.current)

    sign_in users(:one)
    get admin_dashboard_path

    assert_select ".dashboard-card", text: /Total Views\s*2/
    assert_select ".dashboard-panel", text: /Most-read posts/ do
      assert_select ".ranked-list-label", text: "Butter tips"
      assert_select ".ranked-list-count", text: "2"
    end
  end

  test "renders with no visits" do
    Ahoy::Visit.delete_all
    sign_in users(:one)
    get admin_dashboard_path

    assert_response :success
    assert_select ".dashboard-empty", text: "No visits in the last 30 days."
  end

  test "redirects visitors who aren't admins" do
    get admin_dashboard_path
    assert_redirected_to root_path
  end

  private

  def visit(started_at: 1.hour.ago, page_view: true, **attributes)
    visit = Ahoy::Visit.create!(visit_token: SecureRandom.uuid, visitor_token: SecureRandom.uuid, started_at: started_at, **attributes)
    visit.events.create!(name: Ahoy::Event::PAGE_VIEW, time: started_at) if page_view
    visit
  end
end
