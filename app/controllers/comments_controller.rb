class CommentsController < ApplicationController
  allow_unauthenticated_access only: :create
  before_action :set_post

  def create
    @comment = @post.comments.build(comment_params)

    if @comment.save
      redirect_to @post, notice: "Comment added."
    else
      redirect_to @post, alert: "Comment could not be saved."
    end
  end

  def destroy
    @comment = @post.comments.find(params[:id])
    @comment.destroy
    redirect_to @post, notice: "Comment removed.", status: :see_other
  end

  private
    def set_post
      @post = Post.find_by!(slug: params[:post_id])
    end

    def comment_params
      params.require(:comment).permit(:body, :author_name)
    end
end
