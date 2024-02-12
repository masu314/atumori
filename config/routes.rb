Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end

  root to: 'homes#top'
  get "terms", to: "homes#terms", as: "terms"
  get "policy", to: "homes#policy", as: "policy"
  get "about", to: "homes#about", as: "about"
  get "check", to: "users#check", as: "destroy_user_check"
  resources :posts do
    resources :favorites, only: [:create, :destroy]
    collection do
      get "get_category_children", defaults: { format: "json" }
    end
  end
  resources :users, only: [:index, :show] do
    resource :follow_relations, only: [:create, :destroy]
    get "followings", to: "follow_relations#followings"
    get "followers", to: "follow_relations#followers"
  end
end
