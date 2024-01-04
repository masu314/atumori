Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  root to: 'home#top'
  get "posts/category/:id" => "posts#categories", as: "category_posts"
  resources :posts do
    resources :favorites, only: [:create, :destroy]
  end
  resources :users, only: [:index, :show] do
    resource :relationships, only: [:create, :destroy]
    get "followings" => "relationships#followings", as: "followings"
    get "followers" => "relationships#followers", as: "followers"
    get :favorites
  end
end
