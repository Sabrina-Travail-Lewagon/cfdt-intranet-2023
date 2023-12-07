class Admin::UsersController < ApplicationController
  before_action :authenticate_user!  # Devise helper pour s'assurer que l'utilisateur est connecté
  before_action :restrict_access_on_mobile
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :set_breadcrumbs, only: [:show, :edit]
  before_action :authorize_user, except: [:new, :create, :index]  # autoriser uniquement pour les actions spécifiées
  layout "admin-bar"

  def index
    @users = policy_scope(User)  # Utilise Pundit pour filtrer les utilisateurs que l'on peut voir
    @breadcrumbs = [
      {name: 'Accueil', path: root_path},
      {name: 'Dashboard', path: admin_root_path},
      {name: 'Liste des utilisateurs', path: admin_users_path}
    ]
  end

  def show
  end

  def edit
  end

  def update
    # S'assure que l'utilisateur ne met à jour que son propre compte
    unless current_user == @user
      redirect_to admin_user_path(current_user), alert: 'Vous ne pouvez mettre à jour que votre propre compte.'
      return
    end

    # Avant de mettre à jour l'utilisateur, vérification si le mot de passe et la confirmation du mot de passe sont vides
    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end
    if @user.update(user_params)
      redirect_to admin_user_path(@user), notice: 'L\'utilisateur a bien été modifié!'
    else
      render :edit
    end
  end


  def destroy
    if @user.destroy
      redirect_to admin_users_url, notice: 'L\'utilisateur a été supprimé'
    else
      redirect_to admin_users_url, alert: 'Erreur lors de la suppression de l\'utilisateur'
    end
  end

  def new
    @user = User.new
    authorize @user  # Vérifie si l'utilisateur actuel peut créer un nouvel utilisateur
    @breadcrumbs = [
      {name: 'Accueil', path: root_path},
      {name: 'Dashboard', path: admin_root_path},
      {name: 'Créer un utilisateur', path: new_admin_user_path}
    ]
  end

  def create
    @user = User.new(user_params)
    authorize @user  # Utilise Pundit pour vérifier que l'utilisateur actuel peut créer un utilisateur
    if @user.save
      redirect_to admin_user_path(@user), notice: 'L\'utilisateur a été créé!'
    else
      render :new
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
    authorize @user
  end

  def set_breadcrumbs
    @breadcrumbs = [
      {name: 'Accueil', path: root_path},
      {name: 'Dashboard', path: admin_root_path},
      {name: 'Mon compte', path: edit_user_registration_path}
    ]
  end

  # Séparer l'autorisation pour éviter des répétitions
  def authorize_user
    authorize @user
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :role, :photo)
  end

  # Restriction de l'accès sur mobile
  def restrict_access_on_mobile
    redirect_to root_path, alert: "L'accès admin n'est pas disponible sur les téléphones" if device_type == :mobile
  end

end
