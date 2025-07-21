class Post < ApplicationRecord
  # 1つの投稿に1枚画像を添付できるようにする
  has_one_attached :image
  # counter_chacheで投稿数を自動的にカウントし、読み取りを高速化
  belongs_to :user, counter_cache: true
  # 投稿が削除されたらお気に入りも削除
  has_many :favorites, dependent: :destroy
  # 中間テーブル「favorites」を経由して、userモデルと多対多の関係
  has_many :users, through: :favorites
  # 投稿が削除されたら投稿とタグの関連情報も削除
  has_many :post_tag_relations, dependent: :destroy
  # 中間テーブル「post_tag_relations」を経由して、tagモデルと多対多の関係
  has_many :tags, through: :post_tag_relations
  belongs_to :category


  # 投稿タイトルを必須化、かつ20文字以内に制限
  validates :title, presence: true, length: { maximum: 20 }
  # 投稿に紐づく作品IDを必須化
  validates :work_id, presence: true
  # 投稿に紐づく作者IDを必須化
  validates :author_id, presence: true
  # 本文は200文字以内に制限
  validates :text, length: { maximum: 200 }
  # 画像の添付は必須
  validates :image, presence: true
  # 画像サイズチェック
  validate :image_size

  # 画像サイズが5MBを超えていないかチェック
  def image_size
    if image.attached? && image.blob.byte_size > 5.megabytes
      errors.add(:image, 'は5MB以下である必要があります。')
    end
  end

  # ransack用のカスタム検索項目を定義し、お気に入り数で並び替えできるようにする
  ransacker :favorites_count do
    query = '(SELECT COUNT(favorites.post_id) FROM favorites where favorites.post_id = posts.id GROUP BY favorites.post_id)'
    Arel.sql(query)
  end

  # タグの作成、削除
  def save_tags(tags)
    # 入力されたタグを確認
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    old_tags = current_tags - tags
    new_tags = tags - current_tags

    # 編集画面で削除された既存のタグをデータベースから削除する
    old_tags.each do |old_name|
      tag = Tag.find_by(name: old_name)
      self.tags.destroy(tag)
    end

    # 新たに入力されたタグをデータベースに追加（重複しているタグは追加しない）
    new_tags.uniq.each do |new_name|
      # タグを探してなければ、新しく作る
      tag = Tag.find_or_create_by(name: new_name)
      self.tags << tag
    end
  end
end
