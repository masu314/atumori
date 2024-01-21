class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:twitter]

  validates :name, presence: true, length: { maximum: 20 }
  validates :profile, length: { maximum: 200 }
  validate :image_size

  attr_accessor :current_password
  has_one_attached :user_image
  has_many :posts, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorites_posts, through: :favorites, source: :post
  has_many :active_follow_relations, class_name: "FollowRelation", foreign_key: "follower_id", dependent: :destroy
  has_many :passive_follow_relations, class_name: "FollowRelation", foreign_key: "followed_id", dependent: :destroy
  has_many :followings, through: :active_follow_relations, source: :followed
  has_many :followers, through: :passive_follow_relations, source: :follower

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
    active_follow_relations.create(followed_id: user.id)
  end

  def unfollow(user)
    active_follow_relations.find_by(followed_id: user.id).destroy
  end

  def following?(user)
    followings.include?(user)
  end

  ransacker :followers_count do
    query = '(SELECT COUNT(follow_relations.followed_id) FROM follow_relations where follow_relations.followed_id = users.id GROUP BY follow_relations.followed_id)'
    Arel.sql(query)
  end

  ransacker :posts_count do
    query = '(SELECT COUNT(posts.user_id) FROM posts where posts.user_id = users.id GROUP BY posts.user_id)'
    Arel.sql(query)
  end

  def update_without_current_password(params, *options)
    if params[:password].blank? && params[:password_confirmation].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
    end

    result = update(params, *options)
    clean_up_passwords
    result
  end

  def self.find_for_oauth(auth)
    user = User.find_by(uid: auth.uid, provider: auth.provider)
    user ||= User.create!(
      uid: auth.uid,
      provider: auth.provider,
      name: auth[:info][:name],
      email: User.dummy_email(auth),
      password: Devise.friendly_token[0, 20]
    )
  end

  def self.dummy_email(auth)
    "#{Time.now.strftime('%Y%m%d%H%M%S').to_i}-#{auth.uid}-#{auth.provider}@example.com"
  end

  def image_size
    if user_image.attached? && user_image.blob.byte_size > 5.megabytes
      errors.add(:user_image, 'は5MB以下である必要があります。')
    end
  end
end
