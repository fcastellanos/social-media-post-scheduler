class Post < ApplicationRecord
  validates :title, presence: true
  validates :content, presence: true
  validates :scheduled_date, presence: true
  validate :scheduled_date_cannot_be_in_the_past

  has_many :photos, dependent: :destroy
  accepts_nested_attributes_for :photos

  private

  def scheduled_date_cannot_be_in_the_past
    return if scheduled_date.blank?

    # Compare in UTC to avoid timezone surprises from client input
    if scheduled_date.to_time < Time.current
      errors.add(:scheduled_date, "can't be in the past")
    end
  end
end
