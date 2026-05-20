class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end
  def create
    @user = User.new(user_params)

    # admin decides role (default fallback if not provided)
    @user.role = params[:user][:role].presence || "author"

    if @user.save
      redirect_to users_path, notice: "User created successfully"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @user = User.find(params[:id])

    # update normal fields
    if @user.update(user_params)

      @user.update(role: params[:user][:role]) if params[:user][:role].present?

      redirect_to users_path, notice: "User updated successfully"
    else
      redirect_to users_path, alert: "Could not update user"
    end
  end





  private

  def require_admin
    redirect_to root_path, alert: "Not authorized" unless current_user.admin?
  end

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
end
