class Users::RegistrationsController < Devise::RegistrationsController
  before_action :ensure_normal_user, only: ["update", "destroy"]

  def ensure_normal_user
    redirect_to root_path, alert: 'ゲストユーザーの更新・削除はできません。' if resource.email == 'guest@example.com'
  end

  protected

  # パスワードを入力せずにアカウントを編集できるように設定
  def update_resource(resource, params)
    resource.update_without_current_password(params)
  end

  # アカウント編集後のリダイレクト先をユーザーページに変更するように設定
  def after_update_path_for(resource)
    user_path(resource)
  end
end
