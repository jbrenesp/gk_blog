class PostsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show blog]
  before_action :set_post, only: %i[show edit update destroy publish]

  before_action :require_admin, only: %i[destroy publish]
  before_action :authorize_owner_or_admin, only: %i[edit update]

  # GET /posts (HOME PAGE)
  def index
    scope = current_user&.admin? ? Post.all : Post.where(status: :published)

    @latest_post = scope.order(created_at: :desc).first
  end

  # GET /blog (ALL PUBLISHED POSTS)
  def blog
    @posts = Post.where(status: :published).order(created_at: :desc)
  end

  # GET /posts/:id
  def show
    if !current_user&.admin? && @post.status != "published"
      redirect_to root_path, alert: "Not authorized"
    end
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/:id/edit
  def edit
  end

  # POST /posts
  def create
    @post = current_user.posts.build(post_params)
    @post.status = :draft

    if @post.save
      redirect_to @post, notice: "Post was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/:id
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: "Post was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/:id
  def destroy
    @post.destroy!

    respond_to do |format|
      format.html { redirect_to posts_path, notice: "Post was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  # PATCH /posts/:id/publish
  def publish
    @post.update(status: :published)
    redirect_to @post, notice: "Post published!"
  end

  private

  # Find post
  def set_post
    @post = Post.find(params[:id])
  end

  # Strong params
  def post_params
    params.require(:post).permit(:title, :body, images: [])
  end

  # Only admins allowed
  def require_admin
    redirect_to root_path, alert: "Not authorized" unless current_user.admin?
  end

  # Only owner or admin can edit/update
  def authorize_owner_or_admin
    unless current_user.admin? || @post.user == current_user
      redirect_to posts_path, alert: "Not authorized"
    end
  end
end
