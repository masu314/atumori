class UsersController < ApplicationController

  def index
    if params[:q].present?
      @q = User.ransack(params[:q])
      @users = @q.result(distinct: true)
    else
      params[:q] = { sorts: 'created_at desc' }
      @q = User.ransack(params[:q])
      @users = @q.result(distinct: true)
    end
  end

  def show
    @user = User.find(params[:id])
    @posts = Post.where(user_id: @user.id)
  end

  def check
  end
end
