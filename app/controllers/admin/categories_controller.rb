class Admin::CategoriesController < ApplicationController
  before_action :authenticate_admin!
  layout "admin-bar"

  def index
    @user = current_user
    # @categories = policy_scope(Category).order('created_at DESC')
    @pagy, @categories = pagy(policy_scope(Category).order('created_at DESC'), items: 5)
  end

  def authenticate_admin!
    # Vérifie si un utilisateur est connecté
    authenticate_user!

    # Vérifie si l'utilisateur connecté est un administrateur ou un RH
    unless current_user.admin? || current_user.rh? || current_user.cse? || current_user.user?
      # Si l'utilisateur n'est pas un admin ou un RH, redirigez-le avec un message d'erreur
      redirect_to root_path, alert: "Vous n'avez pas les autorisations nécessaires pour accéder à cette page."
    end
  end
end
