class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :name, presence: true
  attr_accessor :current_password
  has_one_attached :user_image
  has_many :posts, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorites_posts, through: :favorites, source: :post
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followings, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  def favorite(post)
    favorites_posts << post
  end

  def unfavorite(post)
    favorites_posts.destroy(post)
  end

  def favorite?(post)
    favorites_posts.include?(post)
  end

  def follow(user)
    active_relationships.create(followed_id: user.id)
  end

  def unfollow(user)
    active_relationships.find_by(followed_id: user.id).destroy
  end

  def following?(user)
    followings.include?(user)
  end

  ransacker :followers_count do
    query = '(SELECT COUNT(relationships.followed_id) FROM relationships where relationships.followed_id = users.id GROUP BY relationships.followed_id)'
    Arel.sql(query)
  end

  ransacker :posts_count do
    query = '(SELECT COUNT(posts.user_id) FROM posts where posts.user_id = users.id GROUP BY posts.user_id)'
    Arel.sql(query)
  end
end
