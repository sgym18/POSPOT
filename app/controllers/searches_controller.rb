class SearchesController < ApplicationController

  def search
    @keyword = params[:keyword]
    @user_result = User.search_for(@keyword)
    @user_result = Kaminari.paginate_array(User.search_for(@keyword)).page(params[:user_page]).per(6)
    @post_result = Kaminari.paginate_array(Post.search_for(@keyword)).page(params[:post_page]).per(4)
    @tag_result = Kaminari.paginate_array(Tag.search_for(@keyword)).page(params[:tag_page]).per(4)
  end

end
