class PostsController < ApplicationController

  def index
    @posts = Post.all
    gon.posts = @posts
  end

  def show
    @post = Post.find(params[:id])
    gon.post = @post
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
    if @post.save
      @post.save_tags(tag_list)
      redirect_to post_path(@post), notice: "変更を保存しました"
    else
      render :edit
    end
  end

  def map
    results = Geocoder.search(params[:address])
    @latlng = results.first.coordinates
    respond_to do |format|
      format.js
    end
  end

  private
  def post_params
    params.require(:post).permit(:spot, :caption, :address, :image)
  end
end
