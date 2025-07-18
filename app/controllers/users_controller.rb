class UsersController < ApplicationController
  # 確認画面でログインユーザーか確認
  before_action :authenticate_user!, only: [:check]

  # ユーザー一覧を取得
  def index
    # 検索条件が渡された場合、その条件でユーザーを絞り込む
    if params[:q].present?
      @q = User.includes([:user_image_attachment]).ransack(params[:q])
      # 重複を排除して検索結果を取得
      @users = @q.result(distinct: true)
    else
      # 検索条件がない場合、作成日順でユーザーを取得
      params[:q] = { sorts: 'created_at desc' }
      @q = User.includes([:user_image_attachment]).ransack(params[:q])
      # 重複を排除して検索結果を取得
      @users = @q.result(distinct: true)
    end
  end

  # ユーザーの詳細情報を取得
  def show
    @user = User.includes([:user_image_attachment]).find(params[:id])
    @user_posts = Post.with_attached_image.includes([:user]).where(user_id: @user.id)
    @user_favorite_posts = @user.favorite_posts.with_attached_image.includes([:user])
  end

  # ユーザーの作成・編集確認画面を表示させるための処理
  def check
  end
end
