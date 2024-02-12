class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_active_storage_host if Rails.env.test?

  # deviseに関する画面に行った時、configure_permitted_parametersを実行
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_q_for_post

  protected
  # アカウントの新規登録時と更新時のストロングパラメータを設定
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :user_image, :profile, :friend_code])
  end

  # ヘッダーの検索窓から受け取った値を設定
  def set_q_for_post
    @q_header = Post.with_attached_image.includes([:user]).ransack(params[:q])
  end

  # rspecでActiveStorage::Current.hostがnilになってしまうので、下記を設定
  def set_active_storage_host
    ActiveStorage::Current.host = 'http://localhost:3000' if ActiveStorage::Current.host.blank?
  end
end
