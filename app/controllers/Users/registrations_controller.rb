class Users::RegistrationsController < Devise::RegistrationsController
  before_action :ensure_normal_user, only: %i[update destroy]

  def ensure_normal_user
    if resource.email == 'guest@example.com'
      redirect_to root_path, alert: 'ゲストユーザーの更新・削除はできません。'
    end
  end

  protected
  def update_resource(resource, params)
    resource.update_without_current_password(params)
  end

  def after_update_path_for(resource)
    user_path(current_user.id)
  end
end
