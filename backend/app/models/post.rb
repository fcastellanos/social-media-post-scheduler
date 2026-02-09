class Post < ApplicationRecord
  validates :title, presence: true
  validates :content, presence: true
  validates :scheduled_date, presence: true

  has_many :photos, dependent: :destroy
  accepts_nested_attributes_for :photos
end
