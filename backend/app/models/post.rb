class Post < ApplicationRecord
  validates :title, presence: true
  validates :content, presence: true
  validates :scheduled_date, presence: true

  has_many :photos, dependent: :destroy

  belongs_to :property, optional: true
end
