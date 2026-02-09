class PostsController < ApplicationController
  def index
    posts = Post.includes(:photos).all

    render json: posts, include: ['photos']
  end

  def show
    post = Post.includes(:photos).find(params[:id])
    
    render json: post, include: ['photos']
  end

  def create
    post = Post.new(post_params)

    if post.save
      render json: post, status: :created, include: ['photos']
    else
      render json: { errors: post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :content, :scheduled_date, photos_attributes: [:url, :caption])
  end
end
