require "test_helper"

class CookieConsentTest < ActionDispatch::IntegrationTest
  # Ahoy ignores bots, and a blank user agent counts as one
  BROWSER = { "User-Agent" => "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0 Safari/537.36" }.freeze

  test "shows the banner and tracks visits without cookies before consent" do
    assert_difference("Ahoy::Visit.count", 1) { get root_path, headers: BROWSER }

    assert_select ".cookie-banner"
    assert cookies[:ahoy_visit].blank?
    assert cookies[:ahoy_visitor].blank?

    # same browser, same visit
    assert_no_difference("Ahoy::Visit.count") { get blog_path, headers: BROWSER }
  end

  test "accepting continues the current visit with Ahoy cookies" do
    get root_path, headers: BROWSER
    visit = Ahoy::Visit.last

    assert_no_difference("Ahoy::Visit.count") do
      post cookie_consent_path, params: { choice: "accepted" }, headers: BROWSER
    end
    assert_redirected_to root_path
    assert_equal "accepted", cookies[:cookie_consent]
    assert_equal visit.visit_token, cookies[:ahoy_visit]
    assert_equal visit.visitor_token, cookies[:ahoy_visitor]

    assert_no_difference("Ahoy::Visit.count") { get blog_path, headers: BROWSER }
    assert_select ".cookie-banner", count: 0
    assert_select "footer a", text: "Cookie settings"
  end

  test "declining hides the banner without setting Ahoy cookies" do
    post cookie_consent_path, params: { choice: "declined" }, headers: BROWSER
    assert_equal "declined", cookies[:cookie_consent]

    get root_path, headers: BROWSER
    assert_select ".cookie-banner", count: 0
    assert cookies[:ahoy_visit].blank?
    assert cookies[:ahoy_visitor].blank?
  end

  test "declining after accepting removes Ahoy cookies" do
    post cookie_consent_path, params: { choice: "accepted" }, headers: BROWSER
    assert cookies[:ahoy_visit].present?

    post cookie_consent_path, params: { choice: "declined" }, headers: BROWSER
    assert cookies[:ahoy_visit].blank?
    assert cookies[:ahoy_visitor].blank?
  end

  test "cookie settings shows the banner again" do
    post cookie_consent_path, params: { choice: "declined" }, headers: BROWSER

    delete cookie_consent_path, headers: BROWSER
    assert cookies[:cookie_consent].blank?

    get root_path, headers: BROWSER
    assert_select ".cookie-banner"
  end

  test "rejects unknown choices" do
    post cookie_consent_path, params: { choice: "maybe" }, headers: BROWSER
    assert_response :bad_request
    assert cookies[:cookie_consent].blank?
  end

  test "does not track the login page" do
    assert_no_difference("Ahoy::Visit.count") { get new_user_session_path, headers: BROWSER }
  end
end
