class Admin::CategoriesController < ApplicationController
  before_action :authenticate_admin!
  before_action :restrict_access_on_mobile

  before_action :find_category, only: [:show, :edit, :update, :destroy]
  layout "admin-bar"

  def index
    @user = current_user
    # @categories = policy_scope(Category).order('created_at DESC')
    add_breadcrumb('Dashboard', admin_root_path)
    add_breadcrumb('Gestion des catégories', admin_categories_path)
    @pagy, @categories = pagy(policy_scope(Category).order('created_at DESC'), items: 5)
  end

  def new
    @user = current_user
    @category = Category.new
    authorize @category # Vérifie l'autorisation via Pundit
    add_breadcrumb('Dashboard', admin_root_path)
    add_breadcrumb('Créer une catégorie', new_admin_category_path)
  end

  def create
    @category = Category.new(category_params)
    authorize @category # Vérifie l'autorisation via Pundit
    if @category.save
      redirect_to admin_category_path(@category), notice: 'Categorie créée!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # On récupère l'id avec before_action
    add_breadcrumb('Dashboard', admin_root_path)
    add_breadcrumb('Modifier une catégorie', edit_admin_category_path)
  end

  def update
    @user = current_user
    if @category.update(category_params)
      redirect_to admin_categories_path, :notice => "Catégorie a été mis à jour."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    begin
    # On récupère l'id avec before_action
    # On supprime l'enregistrement avec l'id dans la BdD
    @category.destroy
    # On redirige vers la page index
    redirect_to admin_categories_path, status: :see_other, :notice => "Catégorie supprimée!"
    rescue ActiveRecord::InvalidForeignKey
      # Redirigez l'utilisateur avec un message d'erreur
      redirect_to admin_categories_path, alert: "Cette catégorie ne peut pas être supprimée car elle est référencée dans des articles."
    end
  end

  private

  def category_params
    params.require(:category).permit(:nom, :image, :background_color)
  end
  def authenticate_admin!
    # Vérifie si un utilisateur est connecté
    authenticate_user!

    # Vérifie si l'utilisateur connecté est un administrateur ou un RH
    unless current_user.admin? || current_user.rh?
      # Si l'utilisateur n'est pas un admin ou un RH, redirigez-le avec un message d'erreur
      redirect_to root_path, alert: "Vous n'avez pas les autorisations nécessaires pour accéder à cette page."
    end
  end
  def find_category
    @category = Category.find(params[:id])
    @user = current_user
    authorize @category
  end
  # Restriction de l'accès sur mobile
  def restrict_access_on_mobile
    redirect_to root_path, alert: "L'accès admin n'est pas disponible sur les téléphones" if device_type == :mobile
  end
end
