Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations',
   :omniauth_callbacks => 'users/omniauth_callbacks'
  }
  root to: 'home#top'
  get "terms" => "home#terms", as: "terms"
  get "policy" => "home#policy", as: "policy"
  get "about" => "home#about", as: "about"
  get "check" => "users#check", as: "destroy_user_check"
  resources :posts do
    resources :favorites, only: [:create, :destroy]
    collection do
      get "get_category_children", defaults: { format: "json" }
    end
  end
  resources :users, only: [:index, :show] do
    resource :user_relationships, only: [:create, :destroy]
    get "followings" => "user_relationships#followings", as: "followings"
    get "followers" => "user_relationships#followers", as: "followers"
  end
end
