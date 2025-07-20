# ユーザー登録・編集を管理
class Users::RegistrationsController < Devise::RegistrationsController
  # ゲストユーザーの更新・削除を禁止
  before_action :ensure_normal_user, only: ["update", "destroy"]

  # ゲストユーザーの場合はtopページに遷移させ、警告メッセージを表示
  def ensure_normal_user
    redirect_to root_path, alert: 'ゲストユーザーの更新・削除はできません。' if resource.email == 'guest@example.com'
  end

  protected
  # 現在のパスワードを入力せずにユーザー情報を編集できるように設定
  def update_resource(resource, params)
    resource.update_without_current_password(params)
  end

  # ユーザー情報編集後のリダイレクト先をユーザーページに変更するように設定
  def after_update_path_for(resource)
    user_path(resource)
  end
end
