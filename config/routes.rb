Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  resources :articles
  resources :categories do
    resources :articles
  end
  # Partie dashboard
  namespace :admin do
    get 'articles/mes_articles', to: 'articles#mes_articles', as: 'mes_articles'
    resources :articles
    resources :categories
    resources :users
    root to: 'articles#new'
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
