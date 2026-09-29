class CookieConsentsController < ApplicationController
  CHOICES = %w[accepted declined].freeze

  def create
    choice = params[:choice].presence_in(CHOICES)
    return head :bad_request unless choice

    cookies[:cookie_consent] = { value: choice, expires: 1.year.from_now, same_site: :lax, httponly: true }

    if choice == "accepted"
      keep_current_visit
    else
      ahoy.reset
    end

    redirect_back_or_to root_path, status: :see_other
  end

  # "Cookie settings" in the footer: forget the choice so the banner shows again
  def destroy
    cookies.delete(:cookie_consent)
    redirect_back_or_to root_path, status: :see_other
  end

  private

  # Ahoy already tracked this request's visit without cookies. Read its tokens
  # before switching cookies on, so accepting continues that visit instead of
  # starting a second one.
  def keep_current_visit
    ahoy.visit_token
    ahoy.visitor_token
    Current.analytics_cookies = true
    ahoy.set_visitor_cookie
    ahoy.set_visit_cookie
  end
end
