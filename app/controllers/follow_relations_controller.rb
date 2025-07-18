class FollowRelationsController < ApplicationController
  # フォローとアンフォローのアクションの前に、ユーザーがログインしているかを確認
  before_action :authenticate_user!, only: [:create, :destroy]

   # ユーザーをフォロー
  def create
    user = User.find(params[:user_id])
    current_user.follow(user)
    redirect_to request.referer
  end
  
  # フォローを解除
  def destroy
    user = User.find(params[:user_id])
    current_user.unfollow(user)
    redirect_to  request.referer
  end
  
  # フォローしているユーザーの一覧を取得
  def followings
    @user = User.find(params[:user_id])
    @users = @user.followings.includes([:user_image_attachment])
  end
  
  # フォロワーの一覧を取得
  def followers
    @user = User.find(params[:user_id])
    @users = @user.followers.includes([:user_image_attachment])
  end
end
