class Micropost < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_one_attached :image
  default_scope -> {order(created_at: :desc)}
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140}
  validates :image, content_type: { in: %w[image/jpeg image/png], message: "jpegもしくはpngに変更してください"},
  size: { less_than: 5.megabytes, message: "5MB以下人変更してください"}

  def display_image
    image.variant(resize_to_limit: [500, 500])
  end
end
