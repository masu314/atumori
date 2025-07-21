class Tag < ApplicationRecord
  # タグが削除されたら、タグと投稿の関連情報も削除する
  has_many :post_tag_relations, dependent: :destroy
  # 中間テーブル「post_tag_relations」を通じて、複数の投稿と紐付ける
  has_many :posts, through: :post_tag_relations
  # タグ名を必須化
  validates :name, presence: true
end
