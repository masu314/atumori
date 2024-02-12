class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    post = Post.find(params[:post_id])
    current_user.favorite(post)
    redirect_to request.referer
  end

  def destroy
    post = current_user.favorite_posts.find(params[:post_id])
    current_user.unfavorite(post)
    redirect_to request.referer
  end
end
