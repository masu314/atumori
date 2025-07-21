class Category < ApplicationRecord
  # カテゴリーを多階層にする
  has_ancestry
  # カテゴリーが削除されるとそれに紐づく投稿も削除する
  has_many :posts, dependent: :destroy
end
