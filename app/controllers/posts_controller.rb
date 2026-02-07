class PostsController < ApplicationController
  allow_unauthenticated_access only: %i[index show]
  before_action :set_post, only: %i[show edit update destroy]

  def index
    @posts = if authenticated? && Current.user
      Post.recent.where("published_at IS NOT NULL OR user_id = ?", Current.user.id)
    else
      Post.published.recent
    end

    if params[:tag].present?
      @posts = @posts.joins(:tags).where(tags: { name: params[:tag].downcase })
    end

    @pagy, @posts = pagy(@posts, limit: 10)
  end

  def show
  end

  def new
    @post = Post.new
  end

  def create
    @post = Current.user.posts.build(post_params)

    if @post.save
      redirect_to @post, notice: "Post created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: "Post updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_url, notice: "Post deleted.", status: :see_other
  end

  private
    def set_post
      @post = Post.find_by!(slug: params[:id])
    end

    def post_params
      params.require(:post).permit(:title, :body, :published_at, :tag_list)
    end
end
