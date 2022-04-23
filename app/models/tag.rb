class Tag < ApplicationRecord
  has_many :post_tags, foreign_key: "tag_id", dependent: :destroy
  has_many :posts, through: :post_tags

  # タグ検索
  def self.search_for(keyword)
    return Post.joins(:tags).where("tags.name LIKE(?)", "%#{keyword}%").distinct()
  end
end
