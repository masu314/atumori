class FavoritesController < ApplicationController
  # アクションが実行前に、ユーザーがログインしているかどうか確認
  before_action :authenticate_user!

  # お気に入りに追加
  def create
    post = Post.find(params[:post_id])
    current_user.favorite(post)
    redirect_to request.referer
  end

  # お気に入りから削除
  def destroy
    post = current_user.favorite_posts.find(params[:post_id])
    current_user.unfavorite(post)
    redirect_to request.referer
  end
end
