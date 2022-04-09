class PostComment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :comment,length: { minimum: 1, maximum: 255 }, presence: true
end
