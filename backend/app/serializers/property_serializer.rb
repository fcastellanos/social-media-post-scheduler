class PropertySerializer < ActiveModel::Serializer
  attributes :id, :name, :address, :city, :state, :zip, :latitude, :longitude

  has_many :posts
end