Rails.application.routes.draw do
  devise_for :users
  get 'home/top'

  resources :posts
  
end
