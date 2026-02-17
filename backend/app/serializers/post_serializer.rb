class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :content, :scheduled_date, :created_at, :updated_at, :property_id

  has_many :photos

  belongs_to :property
end
