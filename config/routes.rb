Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  root to: 'home#top'

  resources :posts do
    resources :favorites, only: %i[create destroy]
    collection do
      get :favorites
    end
  end
  resources :users
end
