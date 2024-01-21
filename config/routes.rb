Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations',
   :omniauth_callbacks => 'users/omniauth_callbacks'
  }
  root to: 'homes#top'
  get "terms" => "homes#terms", as: "terms"
  get "policy" => "homes#policy", as: "policy"
  get "about" => "homes#about", as: "about"
  get "check" => "users#check", as: "destroy_user_check"
  resources :posts do
    resources :favorites, only: [:create, :destroy]
    collection do
      get "get_category_children", defaults: { format: "json" }
    end
  end
  resources :users, only: [:index, :show] do
    resource :follow_relations, only: [:create, :destroy]
    get "followings" => "follow_relations#followings", as: "followings"
    get "followers" => "follow_relations#followers", as: "followers"
  end
end
