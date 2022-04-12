class PostsController < ApplicationController
  before_action :ensure_guest_user, only: [:new, :edit]

  def index
    @posts = Post.all
    gon.user = current_user
  end

  def show
    @post = Post.find(params[:id])
    gon.post = @post
    @post_comment = PostComment.new
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    tag_list = params[:post][:tag_name].split(",")
    if @post.save
      @post.save_tags(tag_list)
      redirect_to post_path(@post), notice: "投稿しました。"
    else
      render :new
    end
  end

  def edit
    @post = Post.find(params[:id])
    @tag_list = @post.tags.pluck(:name).join(",")
  end

  def update
    @post = Post.find(params[:id])
    tag_list = params[:post][:tag_name].split(",")
    if @post.update(post_params)
      @post.save_tags(tag_list)
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

  def map
    results = Geocoder.search(params[:address])
    @latlng = results.first.coordinates
    respond_to do |format|
      format.js
    end
  end

  private

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
