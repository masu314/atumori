class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    @posts = Post.where(user_id: @user.id)
    @favorite_posts = current_user.favorites_posts
  end

end
