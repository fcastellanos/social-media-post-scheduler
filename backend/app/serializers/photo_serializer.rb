class PhotoSerializer < ActiveModel::Serializer
  attributes :id, :url, :caption, :post_id, :created_at, :updated_at

  belongs_to :post
end
