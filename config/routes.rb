Rails.application.routes.draw do
  devise_for :users, skip: [:registrations]
  as :user do
    get 'users/edit', to: 'devise/registrations#edit', as: 'edit_user_registration'
    put 'users', to: 'devise/registrations#update', as: 'user_registration'
  end


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
    resources :users, only: [:new, :create, :update, :index, :show, :edit, :destroy]
    root to: 'articles#new'
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
