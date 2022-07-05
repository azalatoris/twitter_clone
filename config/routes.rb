Rails.application.routes.draw do
  root "homepages#index"
  get "/about", to: "homepages#about"

  resources :tweets
  resources :users
  resources :likes

  namespace :api do
    resources :users, only: %i[create index show update destroy]
  end
end
