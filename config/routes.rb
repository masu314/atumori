Rails.application.routes.draw do
  get 'home/top'

  resources :postss
  
end
