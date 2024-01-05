class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :search

  def set_search
      @post_q = Post.ransack(params[:q])
  end

  def search
    @model = params["model"]
    @content = params["content"]
    @serach_result = search_for(@model, @content)
  end

  private
  def search_for(model, content)
    if model == 'user'
      User.where('name LIKE ?', '%'+content+'%')
    elsif model == 'post'
      Post.where('title LIKE ?', '%'+content+'%')
    end
  end

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :user_image, :profile, :friend_code])
  end
end
