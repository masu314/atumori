class ApplicationController < ActionController::Base
  # CSRF 攻撃から保護し、無効なトークンのリクエストを拒否
  protect_from_forgery with: :exception
  # テスト環境の場合、テスト用のActiveStorageのホストを設定
  before_action :set_active_storage_host if Rails.env.test?

  # devise関連の画面（サインイン、サインアップ、プロフィール更新など）が表示される前に、許可するパラメータを設定
  before_action :configure_permitted_parameters, if: :devise_controller?
  # 継承先コントローラーでアクション前に投稿検索用のクエリを設定
  before_action :set_q_for_post

  protected
  # アカウントの新規登録時と更新時に許可するパラメータを設定
  def configure_permitted_parameters
    # 新規登録時に name パラメータを許可
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    # アカウント更新時に、name, user_imaege, profile, friend_code パラメータを許可
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :user_image, :profile, :friend_code])
  end

  # ヘッダーの検索フォームの設定
  def set_q_for_post
    # 投稿の添付画像とユーザー情報を事前に読み込み、検索条件に基づいて検索結果を取得
    @q_header = Post.with_attached_image.includes([:user]).ransack(params[:q])
  end

  # rspecテスト時にActiveStorage::Current.hostがnilになるのを防ぐ
  def set_active_storage_host
    ActiveStorage::Current.host = 'http://localhost:3000' if ActiveStorage::Current.host.blank?
  end
end
