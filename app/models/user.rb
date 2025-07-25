class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:twitter]
  has_one_attached :user_image
  has_many :posts, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_posts, through: :favorites, source: :post
  has_many :active_follow_relations, class_name: "FollowRelation", foreign_key: "follower_id", inverse_of: :follower, dependent: :destroy
  has_many :passive_follow_relations, class_name: "FollowRelation", foreign_key: "followed_id", inverse_of: :followed, dependent: :destroy
  has_many :followings, through: :active_follow_relations, source: :followed
  has_many :followers, through: :passive_follow_relations, source: :follower

  validates :name, presence: true, length: { maximum: 20 }
  validates :profile, length: { maximum: 200 }
  validate :image_size

  def image_size
    if user_image.attached? && user_image.blob.byte_size > 5.megabytes
      errors.add(:user_image, 'は5MB以下である必要があります。')
    end
  end

  # ransackerを使って、フォロワー数のカスタム検索を設定
  ransacker :followers_count do
    query = '(SELECT COUNT(follow_relations.followed_id) FROM follow_relations where follow_relations.followed_id = users.id GROUP BY follow_relations.followed_id)'
    Arel.sql(query)
  end

  # ransackerを使って、投稿数のカスタム検索を設定
  ransacker :posts_count do
    query = '(SELECT COUNT(posts.user_id) FROM posts where posts.user_id = users.id GROUP BY posts.user_id)'
    Arel.sql(query)
  end

  # お気に入り登録
  def favorite(post)
    favorite_posts << post
  end

  # お気に入り登録解除
  def unfavorite(post)
    favorite_posts.destroy(post)
  end

  # お気に入り登録しているか確認する（お気に入り登録していればtrueを返す）
  def favorite?(post)
    favorite_posts.include?(post)
  end

  # フォローする
  def follow(user)
    active_follow_relations.create(followed_id: user.id)
  end

  # フォローを解除する
  def unfollow(user)
    active_follow_relations.find_by(followed_id: user.id).destroy
  end

  # フォローの確認をする（フォローしていればtrueを返す）
  def following?(user)
    followings.include?(user)
  end

  # 現在のパスワードがない場合でも、パスワードを更新できるようにする
  def update_without_current_password(params, *options)
    # パスワードと確認用のパスワードが空欄の時のみ、パスワードなしでアカウント情報を変更できるようにする
    if params[:password].blank? && params[:password_confirmation].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
    end

    result = update(params, *options)
    clean_up_passwords
    result
  end

  # 登録済みのユーザーに、ログインしようとしているTwitterアカウントのユーザーがいないか探し、いなかった場合は新たに作成する
  def self.find_for_oauth(auth)
    find_or_create_by(provider: auth.provider, uid: auth.uid) do |user|
      user.name = auth.info.name
      user.email = User.dummy_email(auth)
      user.password = Devise.friendly_token[0, 6]
    end
  end

  # Twitterアカウント登録用のダミーのデータを作成
  def self.dummy_email(auth)
    "#{Time.now.strftime('%Y%m%d%H%M%S').to_i}-#{auth.uid}-#{auth.provider}@example.com"
  end

  # ゲストアカウントを作成
  def self.guest
    find_or_create_by!(email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "ゲスト"
    end
  end
end
