class Favorite < ApplicationRecord
  belongs_to :user
  # counter_chacheでお気に入り数を自動的にカウントし、読み取りを高速化させる
  belongs_to :post, counter_cache: true
  # ユーザーが同じ投稿に複数回お気に入り登録できないようにするためのバリデーション
  validates :user_id, uniqueness: { scope: :post_id }
end
