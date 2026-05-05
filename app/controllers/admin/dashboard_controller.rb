module Admin
  class DashboardController < ApplicationController
    before_action :authenticate_user!
    before_action :require_admin

    def index
      @posts_count = Post.count
      @users_count = User.count
      @published_posts = Post.where(status: :published).count
      @draft_posts = Post.where(status: :draft).count
      @views_count = Post.sum(:views_count)
    end
  end
end
