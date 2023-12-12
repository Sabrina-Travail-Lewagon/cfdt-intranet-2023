Rails.application.routes.draw do
  devise_for :users, skip: [:registrations]
  # post 'csp_violation_report', to: 'csp_reports#create'
  as :user do
    get 'users/edit', to: 'users/registrations#edit', as: 'edit_user_registration'
    put 'users', to: 'users/registrations#update', as: 'user_registration'
  end

  root to: "pages#home"
  resources :articles do
    resources :comments, only: [:create, :destroy]
    resources :likes, only: [:create, :destroy]
    collection do
      get 'category/:category_id', to: 'articles#index', as: :category
    end
  end
  # resources :categories do
  #   resources :articles
  # end
  # Partie dashboard
  namespace :admin do
    root to: redirect('/admin/users/edit') # Redirige vers edit_user_registration_path
    # gestion de la modification du profil utilisateur
    get 'users/edit', to: 'registrations#edit', as: 'edit_user_registration'
    patch 'users', to: 'registrations#update'
    # Route pour admin pour modif/supp n'importe quel article
    get 'articles/tous_les_articles', to: 'articles#tous_les_articles', as: 'tous_les_articles'
    # root to: 'home#accueil'
    get 'articles/mes_articles', to: 'articles#mes_articles', as: 'mes_articles'
    resources :articles
    resources :categories
    resources :users, only: [:new, :create, :index, :show, :destroy, :edit, :update]
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
