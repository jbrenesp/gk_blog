class Admin::DashboardController < ApplicationController
  before_action :require_admin

  def index
    @posts_count = Post.count
    @published_posts = Post.published.count
    @draft_posts = Post.draft.count

    @users_count = User.count
    @admin_count = User.where(role: :admin).count

    @total_views = Post.sum(:views_count)
  end

  private

  def require_admin
    redirect_to root_path, alert: "Not authorized" unless current_user&.admin?
  end
end
