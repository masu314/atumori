Rails.application.routes.draw do
  get 'home/top'

  resources :posts
  
end
