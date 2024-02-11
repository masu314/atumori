class Category < ApplicationRecord
  # カテゴリーを多階層にする
  has_ancestry
  has_many :posts, dependent: :destroy
end
