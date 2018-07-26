class PostsController < ApplicationController
  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
  end

  def index
    @posts = Post.all
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.create(post_params)
    redirect_to @post
  end

  def update
    @post = Post.find_by(id: params[:id])
    if user_params[:username].empty?
      @post.comments.build(comment_params)
      @post.save
      redirect_to @post
    else
      new_user = User.create(user_params)
      @comment = Comment.new(comment_params)
      @comment.user = new_user
      @post.comments << @comment
      redirect_to @post
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :content, category_ids:[], categories_attributes: [:name])
  end

  def comment_params
    params.require(:comment).permit(:user_id, :content)
  end

  def user_params
    params.require(:user).permit(:username)
  end
end
