class Users::SessionsController < Devise::SessionsController
  before_action :user_state, only: [:create]

  def guest_sign_in
    user = User.guest
    sign_in user
    redirect_to about_path, notice: 'ゲストユーザーでログインしました。'
  end

  protected

  def user_state
    @user = User.find_by(email: params[:user][:email])
    return if !@user
    if @user.valid_password?(params[:user][:password]) && @user.is_deleted
      redirect_to new_user_registration_path, notice: "退会済みユーザーのため新規登録が必要です。"
    end
  end
end