class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :post, counter_cache: true
  # ユーザーが同じ投稿に複数回お気に入り登録できないようにするためのバリデーション
  validates :user_id, uniqueness: { scope: :post_id }
end
