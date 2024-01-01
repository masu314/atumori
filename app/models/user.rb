class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :name, presence: true
  attr_accessor :current_password
  has_one_attached :user_image
  has_many :posts
  has_many :favorites, dependent: :destroy
  has_many :favorites_posts, through: :favorites, source: :post

  def mine?(object)
    object.user_id == id
  end

  def favorite(post)
    favorites_posts << post
  end

  def unfavorite(post)
    favorites_posts.destroy(post)
  end

  def favorite?(post)
    favorites_posts.include?(post)
  end
end
