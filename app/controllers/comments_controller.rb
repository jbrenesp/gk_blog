class CommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.ip_address = request.remote_ip

    if @comment.save
      redirect_to @post, notice: "Comment added!"
    else
      redirect_to @post, alert: @comment.errors.full_messages.to_sentence
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])

    # Only admin can delete comments
    if user_signed_in? && current_user.admin?
      @comment.destroy
      redirect_to @post, notice: "Comment deleted!"
    else
      redirect_to @post, alert: "Not authorized."
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :name, :email)
  end
end
