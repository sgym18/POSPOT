class SearchesController < ApplicationController

  def search
    @keyword = params[:keyword]
    @user_result = Kaminari.paginate_array(User.search_for(@keyword)).page(params[:user_page]).per(4)
    @post_result = Kaminari.paginate_array(Post.search_for(@keyword)).page(params[:post_page]).per(3)
    @tag_result = Kaminari.paginate_array(Tag.search_for(@keyword)).page(params[:tag_page]).per(3)
  end

  def search_post
    @keyword = params[:keyword]
    @post_result = Kaminari.paginate_array(Post.search_for(@keyword)).page(params[:post_page]).per(3)
  end

  def search_tag
    @keyword = params[:keyword]
    @tag_result = Kaminari.paginate_array(Tag.search_for(@keyword)).page(params[:tag_page]).per(3)
  end

  def search_user
    @keyword = params[:keyword]
    @user_result = Kaminari.paginate_array(User.search_for(@keyword)).page(params[:user_page]).per(4)
  end
end
