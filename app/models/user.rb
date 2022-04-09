class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  # フォローするされるの関係
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :reverse_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  # フォロワー、フォロー中ユーザーの一覧
  has_many :followings, through: :relationships, source: :followed
  has_many :followers, through: :reverse_relationships, source: :follower
  has_many :bookmarks, dependent: :destroy

  # バリデーション
  validates :name, length: { minimum: 1, maximum: 30 }, presence: true


  # 経度、緯度取得のため記述
  geocoded_by :address
  after_validation :geocode

  has_one_attached :profile_image

  # ゲストログイン
  def self.guest
    find_or_create_by!(name: "ゲストユーザー" ,email: "guest@example.com") do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "ゲストユーザー"
    end
  end

  # フォロー関係
  def follow(user)
    relationships.create(followed_id: user.id)
  end

  def unfollow(user)
    relationships.find_by(followed_id: user.id).destroy
  end

  def following?(user)
    followings.include?(user)
  end

  # 画像リサイズのため
  def get_profile_image(width, height)
  unless profile_image.attached?
    file_path = Rails.root.join("app/assets/images/no_image.jpg")
    profile_image.attach(io: File.open(file_path), filename: "default-image.jpg", content_type: "image/jpeg")
  end
  profile_image.variant(resize_to_fill: [width, height]).processed
  end
end
