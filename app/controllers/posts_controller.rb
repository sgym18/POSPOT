class PostsController < ApplicationController
  before_action :ensure_correct_user, only: [:edit]
  before_action :ensure_guest_user, only: [:new, :edit]

  def index
    if params[:id]
      bookmarks = Bookmark.where(user_id: current_user.id).pluck(:post_id)
      @bookmark_posts = Post.find(bookmarks).reverse
      gon.posts = @bookmark_posts
    else
      @posts = Post.all.order(created_at: :desc)
      gon.posts = @posts
    end
    gon.user = current_user
  end

  def show
    @post = Post.find(params[:id])
    gon.post = @post
    @post_comment = PostComment.new
    @post_comments = @post.post_comments.order(created_at: :desc)
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    @tag_list = params[:post][:tag_name].split(/ |　/)
    if @post.save
      @post.save_tags(@tag_list)
      redirect_to post_path(@post), notice: "投稿しました。"
    else
      @post.save_tags(@tag_list)
      render :new
    end
  end

  def edit
    @post = Post.find(params[:id])
    @tag_list = @post.tags.pluck(:name).split(/ |　/)
  end

  def update
    @post = Post.find(params[:id])
    @tag_list = params[:post][:tag_name].split(/ |　/)
    if @post.update(post_params)
      @post.save_tags(@tag_list)
      redirect_to post_path(@post), notice: "変更を保存しました"
    else
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to posts_path, notice: "投稿を削除しました"
  end

  private

  def ensure_correct_user
    @post = Post.find(params[:id])
    @user = @post.user
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end

  def ensure_guest_user
    @user = current_user
    if @user.name == "ゲストユーザー"
      redirect_to posts_path, notice: "ゲストユーザーができるのは閲覧のみです。"
    end
  end

  def post_params
    params.require(:post).permit(:spot, :caption, :address, :image)
  end
end
