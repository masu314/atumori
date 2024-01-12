class Post < ApplicationRecord
  has_one_attached :image
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :users, through: :favorites
  belongs_to :category
  validates :user_id, {presence: true}
  
  ransacker :favorites_count do
    query = '(SELECT COUNT(favorites.post_id) FROM favorites where favorites.post_id = posts.id GROUP BY favorites.post_id)'
    Arel.sql(query)
  end
end
