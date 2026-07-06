class Admin::DashboardController < ApplicationController
  before_action :require_admin

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
    @visits_by_day = Ahoy::Visit.where(started_at: 30.days.ago..)
                                 .group("DATE(started_at)")
                                 .order("DATE(started_at)")
                                 .count
  end

  private

  def require_admin
    redirect_to root_path, alert: "Not authorized" unless current_user&.admin?
  end
end
