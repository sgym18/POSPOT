class Post < ApplicationRecord
  belongs_to :user
  # 経度、緯度取得のため記述
  # geocoded_by :address
  # after_validation :geocode

  has_one_attached :image

  def get_image(width, height)
    image.variant(resize_to_limit: [width, height]).processed
  end
end
