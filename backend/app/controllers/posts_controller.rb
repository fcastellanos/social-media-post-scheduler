class PostsController < ApplicationController
  def index
    posts = Post.includes(:photos, :property).all

    render json: posts, include: ['photos', 'property']
  end

  def show
    post = Post.includes(:photos, :property).find(params[:id])
    
    render json: post, include: ['photos', 'property']
  end

  def create
    post = Post.new(post_params)

    if post.save
      render json: post, status: :created, include: ['photos', 'property']
    else
      render json: { errors: post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    head :no_content
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Post not found' }, status: :not_found
  end

  private

  def post_params
    params.require(:post).permit(:title, :content, :scheduled_date, photos_attributes: [:url, :caption])
  end
end
