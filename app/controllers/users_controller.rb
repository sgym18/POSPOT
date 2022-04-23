class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update, :quit_confirm, :quit]
  before_action :ensure_guest_user, only: [:edit, :update, :quit_confirm, :quit]

  def index
    @users = User.page(params[:page]).per(6)
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.order(created_at: :desc)
    gon.posts = @posts
    gon.user = @user
    @followings = @user.followings
    @followers = @user.followers
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "プロフィールを更新しました。"
    else
      render :edit
    end
  end

  def quit_confirm
    @user = User.find(params[:id])
  end

  def quit
    @user = User.find(params[:id])
    @user.update(is_deleted: true)
    reset_session
    redirect_to root_path, notice: "退会しました。"
  end

  private

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end

  def ensure_guest_user
    @user = User.find(params[:id])
    if @user.name == "ゲストユーザー"
      redirect_to user_path(current_user), notice: "ゲストユーザーができるのは閲覧のみです。"
    end
  end

  def user_params
    params.require(:user).permit(:name, :introduction, :address, :profile_image)
  end
end
