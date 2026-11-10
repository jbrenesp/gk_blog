# Called by JavaScript after each page load. Most bots never run JavaScript,
# so visits with a page view are the ones counted as real on the dashboard.
class PageViewsController < ApplicationController
  # The page that sent this request already tracked the visit
  skip_before_action :track_ahoy_visit

  def create
    if ahoy.visit
      ahoy.track Ahoy::Event::PAGE_VIEW, path: params[:path].to_s.first(200)
    end

    head :no_content
  end
end
