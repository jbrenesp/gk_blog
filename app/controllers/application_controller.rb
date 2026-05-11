class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  before_action :track_site_visit

  # Redirect users after login
  def after_sign_in_path_for(resource)
    root_path
  end

  private

  # Safe replacement for custom authentication logic
  def require_login
    unless user_signed_in?
      redirect_to new_user_session_path, alert: "Please log in."
    end
  end

  # Admin-only access helper
  def require_admin
    redirect_to root_path, alert: "Not authorized" unless current_user&.admin?
  end

  def track_site_visit
    return if session[:site_visited]

    site_visit = SiteVisit.first_or_create(visits_count: 0)
    site_visit.increment!(:visits_count)

    session[:site_visited] = true
  end
end
