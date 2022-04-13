class UsersController < ApplicationController
  before_action :ensure_guest_user, only: [:show, :edit, :update, :quit_confirm, :quit]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
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

  def ensure_guest_user
    @user = User.find(params[:id])
    if @user.name == "ゲストユーザー"
      redirect_to users_path, notice: "ゲストユーザーができるのは閲覧のみです。"
    end
  end

  def user_params
    params.require(:user).permit(:name, :introduction, :address, :profile_image)
  end
end
