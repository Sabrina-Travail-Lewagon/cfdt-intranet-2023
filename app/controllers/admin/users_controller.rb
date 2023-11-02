class Admin::UsersController < ApplicationController
  before_action :authenticate_user!  # Devise helper pour s'assurer que l'utilisateur est connecté
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user, except: [:new, :create, :index]  # autoriser uniquement pour les actions spécifiées
  before_action :set_breadcrumbs
  layout "admin-bar"

  def index
    @users = policy_scope(User)  # Utilise Pundit pour filtrer les utilisateurs que l'on peut voir
  end

  def show
  end

  def edit
    add_breadcrumb('Accueil', root_path)
    add_breadcrumb('Dashboard', admin_root_path)
    add_breadcrumb('Mon compte', admin_user_path)
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
  # Séparer l'autorisation pour éviter des répétitions
  def authorize_user
    authorize @user
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :role, :photo)
  end

  def set_breadcrumbs
    @breadcrumbs = [['Dashboard', admin_root_path]]
  end

end
