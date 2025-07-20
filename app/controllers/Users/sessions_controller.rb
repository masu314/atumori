# ユーザーのログイン・ログアウトを管理
class Users::SessionsController < Devise::SessionsController
  # ゲストユーザーとしてログインした際の処理
  def guest_sign_in
    # ゲストユーザーを取得または作成
    user = User.guest
    # ゲストユーザーでログイン
    sign_in user
    # topページに遷移させ、通知を表示
    redirect_to root_path, notice: 'ゲストユーザーとしてログインしました。'
  end
end
