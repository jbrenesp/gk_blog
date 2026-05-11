module Admin
  class PostsController < ApplicationController
    before_action :authenticate_user!
    before_action :require_admin

    def index
      @status = params[:status]

      @posts = Post.all

      case @status
      when "published"
        @posts = @posts.where(status: :published)
      when "draft"
        @posts = @posts.where(status: :draft)
      end
    end
  end
end
