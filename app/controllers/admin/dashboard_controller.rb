class Admin::DashboardController < ApplicationController
  before_action :require_admin

  POST_PATH = %r{\A/posts/(\d+)\z}
  PAGE_NAMES = { "/" => "Home page", "/blog" => "Blog" }.freeze

  def index
    @posts_count = Post.count
    @published_posts = Post.published.count
    @draft_posts = Post.draft.count

    @users_count = User.count
    @admin_count = User.where(role: :admin).count

    @total_views = Post.sum(:views_count).to_i

    @total_visits = Ahoy::Visit.count
    @visits_today = Ahoy::Visit.where(started_at: Time.zone.now.beginning_of_day..).count
    @visits_this_week = Ahoy::Visit.where(started_at: 7.days.ago..).count
    @visits_this_month = Ahoy::Visit.where(started_at: 30.days.ago..).count

    # Last 30 days, including today
    recent = Ahoy::Visit.where(started_at: 29.days.ago.beginning_of_day..)
    @visits_by_day = visits_by_day(recent)
    @top_pages = top_pages(recent)
    @top_referrers = top_referrers(recent)
    @top_devices = top_values(recent, :device_type)
    @top_browsers = top_values(recent, :browser)

    @most_read_posts = Post.published.where("views_count > 0").order(views_count: :desc).limit(5)
  end

  private

  def require_admin
    redirect_to root_path, alert: "Not authorized" unless current_user&.admin?
  end

  # { date => count } for every day, including days without visits
  def visits_by_day(visits)
    counts = visits.group("DATE(started_at)").count
    (29.days.ago.to_date..Date.current).index_with { |day| counts[day] || 0 }
  end

  # [[label, count, path], ...] by landing page; post pages show the post title
  def top_pages(visits)
    paths = visits.where.not(landing_page: nil).pluck(:landing_page).map { |url| url_path(url) }
    top = paths.tally.max_by(5) { |_, count| count }

    post_ids = top.filter_map { |path, _| path[POST_PATH, 1] }
    titles = Post.where(id: post_ids).pluck(:id, :title).to_h { |id, title| [ id.to_s, title ] }

    top.map do |path, count|
      title = titles[path[POST_PATH, 1]]
      [ title.presence || PAGE_NAMES[path] || path, count, path ]
    end
  end

  def url_path(url)
    URI.parse(url).path.presence || "/"
  rescue URI::InvalidURIError
    "/"
  end

  # Other sites that sent visitors, plus visits with no referrer (typed URL, bookmarks, some apps)
  def top_referrers(visits)
    host = request.host.delete_prefix("www.")
    external = visits.where.not(referring_domain: [ nil, "", host, "www.#{host}" ])
    counts = external.group(:referring_domain).count
    direct = visits.where(referring_domain: [ nil, "" ]).count
    counts["Direct / no referrer"] = direct if direct.positive?
    counts.max_by(5) { |_, count| count }
  end

  def top_values(visits, column)
    visits.group(column).count
          .each_with_object(Hash.new(0)) { |(value, count), totals| totals[value.presence || "Unknown"] += count }
          .max_by(5) { |_, count| count }
  end
end
