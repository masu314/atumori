class Post < ApplicationRecord
  has_one_attached :image
  belongs_to :user, counter_cache: true
  has_many :favorites, dependent: :destroy
  has_many :users, through: :favorites
  has_many :post_tag_relations, dependent: :destroy
  has_many :tags, through: :post_tag_relations
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

  def save_tags(tags)
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    old_tags = current_tags - tags
    new_tags = tags - current_tags

    old_tags.each do |old_name|
      self.tags.delete Tag.find_by(name: old_name)
      binding.pry
    end

    new_tags.each do |new_name|
      tag = Tag.find_or_create_by(name: new_name)
      self.tags << tag
    end
  end
end
