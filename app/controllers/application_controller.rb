class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  #deviseに関する画面に行った時、configure_permitted_parametersを実行
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_q_for_post

  protected
  #アカウントの新規登録時と更新時のストロングパラメータを設定
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :user_image, :profile, :friend_code])
  end

  def set_q_for_post
    @q_header = Post.with_attached_image.includes([:user]).ransack(params[:q])
  end
end
