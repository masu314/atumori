# 投稿とタグの多対多の関係を表す中間テーブルを定義
class PostTagRelation < ApplicationRecord
  belongs_to :post
  belongs_to :tag
end
