class RelationshipsController < ApplicationController

  def create
    @user = User.find(params[:user_id])
    current_user.follow(@user)
    @followings = @user.followings
    @followers = @user.followers
  end

  def destroy
    @user = User.find(params[:user_id])
    current_user.unfollow(@user)
    @followings = @user.followings
    @followers = @user.followers
  end
end
