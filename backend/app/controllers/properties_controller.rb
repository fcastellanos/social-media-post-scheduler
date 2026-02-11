class PropertiesController < ApplicationController
  def index
    properties = Property.includes(:posts).all

    render json: properties, include: ['posts']
  end
end
