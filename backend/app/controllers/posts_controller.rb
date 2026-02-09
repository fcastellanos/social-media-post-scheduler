class PostsController < ApplicationController
  def index
    posts = Post.includes(:photos).all

    render json: posts.as_json(include: { photos: { only: [:id, :url, :caption, :post_id] } })
  end

  def show
    post = Post.includes(:photos).find(params[:id])

    render json: post.as_json(include: { photos: { only: [:id, :url, :caption, :post_id] } })
  end
end
