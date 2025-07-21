# ユーザー同士の多対多の関係を表す中間テーブルを定義
class FollowRelation < ApplicationRecord
  # 関連名とモデル名が異なるため、class_nameでモデル名を指定
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
end
