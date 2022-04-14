class Admin::UsersController < ApplicationController
  before_action :if_not_admin

  def index
    if params[:status] == "有効"
      @users = User.where(is_deleted: false)
    elsif params[:status] == "退会"
      @users = User.where(is_deleted: true)
    else
      @users = User.all
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to admin_user_path(@user), notice: "ユーザー情報を更新しました。"
    else
      render :show
    end
  end

  private

  def if_not_admin
    redirect_to root_path unless current_user.admin?
  end

  def user_params
    params.require(:user).permit(:name, :introduction, :address, :is_deleted)
  end
end
