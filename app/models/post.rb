class Post < ApplicationRecord
  has_one_attached :image
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :users, through: :favorites
  has_many :post_tag_relations, dependent: :destroy
  has_many :tags, through: :post_tag_relations, dependent: :destroy
  belongs_to :category

  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 20 }
  validates :category_id, presence: true
  validates :work_id, presence: true
  validates :author_id, presence: true
  validates :text, length: { maximum: 200 }
  validates :image, size: { less_than: 5.megabytes, message: "は5MB以下である必要があります。" }

  ransacker :favorites_count do
    query = '(SELECT COUNT(favorites.post_id) FROM favorites where favorites.post_id = posts.id GROUP BY favorites.post_id)'
    Arel.sql(query)
  end
end
