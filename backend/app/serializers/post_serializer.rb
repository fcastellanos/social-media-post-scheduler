class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :content, :scheduled_date, :created_at, :updated_at

  has_many :photos
end
