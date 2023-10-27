Rails.application.routes.draw do
  # get 'categories/index'
  # get 'categories/show'
  # get 'categories/new'
  # get 'categories/edit'
  devise_for :users
  root to: "pages#home"
  resources :articles
  resources :categories do
    resources :articles
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
