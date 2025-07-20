# 外部サービスを使ったログイン処理
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # Twitterでの認証に成功した場合の処理
  def twitter
    @user = User.find_for_oauth(request.env['omniauth.auth'])

    # 既存ユーザーがいればログイン
    if @user.persisted?
      flash[:notice] = I18n.t('devise.omniauth_callbacks.success', kind: "twitter")
      sign_in_and_redirect @user, event: :authentication
    # 既存ユーザーいない場合セッションにデータを保存し、新規登録データへ
    else
      session["devise.twitter_data"] = request.env['omniauth.auth']
      redirect_to new_user_registration_url
    end
  end

  # 認証失敗時にリダイレクトさせる処理
  def failure
    redirect_to root_path
  end
end
