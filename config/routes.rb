Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  root to: 'home#top'
  resources :posts do
    resources :favorites, only: [:create, :destroy]
    collection do
      get "get_category_children", defaults: { format: "json" }
    end
  end
  resources :users, only: [:index, :show] do
    resource :relationships, only: [:create, :destroy]
    get "followings" => "relationships#followings", as: "followings"
    get "followers" => "relationships#followers", as: "followers"
  end
end
