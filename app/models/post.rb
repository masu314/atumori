class Post < ApplicationRecord
  has_one_attached :image
  belongs_to :user, counter_cache: true
  has_many :favorites, dependent: :destroy
  has_many :users, through: :favorites
  has_many :post_tag_relations, dependent: :destroy
  has_many :tags, through: :post_tag_relations
  belongs_to :category

  validates :title, presence: true, length: { maximum: 20 }
  validates :work_id, presence: true
  validates :author_id, presence: true
  validates :text, length: { maximum: 200 }
  validates :image, presence: true
  validate :image_size

  ransacker :favorites_count do
    query = '(SELECT COUNT(favorites.post_id) FROM favorites where favorites.post_id = posts.id GROUP BY favorites.post_id)'
    Arel.sql(query)
  end

  #タグの作成、更新、削除
  def save_tags(tags)
    #入力されたタグを確認
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    old_tags = current_tags - tags
    new_tags = tags - current_tags

    #元々投稿に追加されていたが、編集画面で削除されたタグをデータベースから削除する
    old_tags.each do |old_name|
      tag = Tag.find_by(name: old_name)
      self.tags.destroy(tag)
    end

    #新たに入力されたタグをデータベースに追加（重複しているタグは追加しない）
    new_tags.uniq.each do |new_name|
      #タグを探してなければ、新しく作る
      tag = Tag.find_or_create_by(name: new_name)
      self.tags << tag
    end
  end

  def image_size
    if image.attached? && image.blob.byte_size > 5.megabytes
      errors.add(:image, 'は5MB以下である必要があります。')
    end
  end
end
