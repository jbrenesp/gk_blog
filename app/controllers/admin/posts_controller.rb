module Admin
  class PostsController < ApplicationController
    before_action :authenticate_user!
    before_action :require_admin

    def index
      @posts = Post.all.order(created_at: :desc)

      if params[:status].present?
        @posts = @posts.where(status: params[:status])
      end
    end
  end
end
