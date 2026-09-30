class SitemapsController < ApplicationController
  def show
    @posts = Post.published.order(updated_at: :desc)
  end
end
