class SearchesController < ApplicationController

  def search
    @keyword = params[:keyword]
    @user_result = User.search_for(@keyword)
    @post_result = Post.search_for(@keyword)
  end
end
