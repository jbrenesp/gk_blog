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

    post_views = post_views_by_id
    @total_views = post_views.values.sum

    # Bots also create visits, but don't run the JavaScript that reports page views
    visits = Ahoy::Visit.with_page_views
    @total_visits = visits.count
    @visits_today = visits.where(started_at: Time.zone.now.beginning_of_day..).count
    @visits_this_week = visits.where(started_at: 7.days.ago..).count
    @visits_this_month = visits.where(started_at: 30.days.ago..).count

    # Last 30 days, including today
    recent = visits.where(started_at: 29.days.ago.beginning_of_day..)
    @visits_by_day = visits_by_day(recent)
    @top_pages = top_pages(recent)
    @top_referrers = top_referrers(recent)
    @top_devices = top_values(recent, :device_type)
    @top_browsers = top_values(recent, :browser)

    @most_read_posts = Post.published.where(id: post_views.keys)
                           .map { |post| [ post, post_views[post.id] ] }
                           .max_by(5) { |_, views| views }
  end

  private

  def require_admin
    redirect_to root_path, alert: "Not authorized" unless current_user&.admin?
  end

  # { post_id => views } from page views reported by real browsers, counting
  # each post once per visit
  def post_views_by_id
    Ahoy::Event.where(name: Ahoy::Event::PAGE_VIEW).where("ahoy_events.properties ->> 'path' ~ '^/posts/[0-9]+$'")
               .group(Arel.sql("ahoy_events.properties ->> 'path'")).distinct.count(:visit_id)
               .transform_keys { |post_path| post_path[POST_PATH, 1].to_i }
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
