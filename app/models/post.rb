class Post < ApplicationRecord
  belongs_to :user
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags
  has_many :bookmarks, dependent: :destroy
  has_many :post_comments, dependent: :destroy

  validates :spot, presence: true
  validates :caption, presence: true
  validates :address, presence: true
  validates :image, presence: true
  # 経度、緯度取得のため記述
  geocoded_by :address
  after_validation :geocode

  has_one_attached :image

  # 画像リサイズのため
  def get_image(width, height)
    image.variant(resize_to_fill: [width, height]).processed
  end

  # tag更新処理
  def save_tags(savepost_tags)
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    old_tags = current_tags - savepost_tags
    new_tags = savepost_tags - current_tags

    old_tags.each do |old_name|
      self.tags.delete Tag.find_by(name:old_name)
    end

    new_tags.each do |new_name|
      post_tag =Tag.find_or_create_by(name:new_name)
      self.tags << post_tag
    end
  end

  def bookmarked_by?(user)
    bookmarks.exists?(user_id: user.id)
  end

  def self.search_for(keyword)
    Post.where(['spot LIKE(?) OR caption LIKE(?) OR address LIKE(?)',"%#{keyword}%","%#{keyword}%","%#{keyword}%"])
  end

end
