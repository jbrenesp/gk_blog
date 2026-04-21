class LikesController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    ip = request.remote_ip

    # Only create a like if this IP hasn't liked this post yet
    unless @post.likes.exists?(ip_address: ip)
      @post.likes.create(ip_address: ip)
    end

    redirect_to @post, notice: "Post liked!"
  end

  def destroy
    @post = Post.find(params[:post_id])
    ip = request.remote_ip

    # Only delete the like that belongs to this IP
    like = @post.likes.find_by(ip_address: ip)
    like&.destroy

    redirect_to @post, notice: "Like removed!"
  end
end
