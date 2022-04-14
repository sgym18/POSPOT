class Tag < ApplicationRecord
  has_many :post_tags, foreign_key: "tag_id", dependent: :destroy
  has_many :posts, through: :post_tags

  def self.search_for(keyword)
    tags = Tag.where("name LIKE(?)", "%#{keyword}%")
    return tags.inject(init = []) {|result, tag| result + tag.posts}
  end
end
