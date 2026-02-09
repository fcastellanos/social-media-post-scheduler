class PostsController < ApplicationController
  def index
    posts = Post.includes(:photos).all

    render json: posts, include: ['photos']
  end

  def show
    post = Post.includes(:photos).find(params[:id])
    
    render json: post, include: ['photos']
  end
end
