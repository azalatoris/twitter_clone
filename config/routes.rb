Rails.application.routes.draw do
  root "homepages#index"
  get "/about", to: "homepages#about"

  resources :tweets
  resources :users
  resources :likes
end
