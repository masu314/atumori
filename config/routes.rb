Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  get "users/account" => "users#account"
  root to: 'home#top'

  resources :posts
  resources :users
  
end
