class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:check]

  def index
    if params[:q].present?
      @q = User.includes([:user_image_attachment]).ransack(params[:q])
      @users = @q.result(distinct: true)
    else
      params[:q] = { sorts: 'created_at desc' }
      @q = User.includes([:user_image_attachment]).ransack(params[:q])
      @users = @q.result(distinct: true)
    end
  end

  def show
    @user = User.includes([:user_image_attachment]).find(params[:id])
    @user_posts = Post.with_attached_image.includes([:user]).where(user_id: @user.id)
    @user_favorite_posts = @user.favorite_posts.with_attached_image.includes([:user])
  end

  def check
  end
end
