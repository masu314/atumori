class UsersController < ApplicationController
  def account
    @user = current_user
  end

  def show
    @user = User.find(params[:id])
    @posts = Post.where(user_id: @user.id)
    @favorite_posts = current_user.favorites_posts
    @favorite_posts = @user.favorites_posts
  end

end
