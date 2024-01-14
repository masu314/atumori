class Post < ApplicationRecord
  has_one_attached :image
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :users, through: :favorites
  belongs_to :category
  validates :user_id, {presence: true}
  validates :title, presence: true, length: { maximum: 20 }
  validates :image, presence: true
  validates :category_id, presence: true
  validates :work_id, presence: true, format: { with: /MO-[A-Z0-9]{4}-[A-Z0-9]{4}-[A-Z0-9]{4}\z/}
  validates :author_id, presence: true, format: { with: /MA-[0-9]{4}-[0-9]{4}-[0-9]{4}\z/}
  
  ransacker :favorites_count do
    query = '(SELECT COUNT(favorites.post_id) FROM favorites where favorites.post_id = posts.id GROUP BY favorites.post_id)'
    Arel.sql(query)
  end
end
