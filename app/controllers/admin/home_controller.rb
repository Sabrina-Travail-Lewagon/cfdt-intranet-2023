class Admin::HomeController < ApplicationController
  before_action :authenticate_user!
  before_action :restrict_access_on_mobile
  after_action :verify_policy_scoped, only: [:index]
  layout "admin-bar"

  def index
    @articles = policy_scope(Article).order('created_at DESC').limit(5)
    @categories = policy_scope(Category)
    authorize @articles
  end

  def accueil

  end

  # Restriction de l'accès sur mobile
  def restrict_access_on_mobile
    redirect_to root_path, alert: "L'accès admin n'est pas disponible sur les téléphones" if device_type == :mobile
  end
end
