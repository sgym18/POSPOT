class Admin::UsersController < ApplicationController
  before_action :if_not_admin

  def index
    if params[:status] == "有効"
      @users = Kaminari.paginate_array(User.where(is_deleted: false)).page(params[:page]).per(10)
    elsif params[:status] == "退会"
      @users = Kaminari.paginate_array(User.where(is_deleted: true)).page(params[:page]).per(10)
    else
      @users = User.page(params[:page]).per(5)
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash.now[:notice] = "ユーザー情報を更新しました。"
    else
      render :error
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
