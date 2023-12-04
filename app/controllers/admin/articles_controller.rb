class Admin::ArticlesController < ApplicationController
  before_action :set_article, only: [:edit, :destroy, :update]
  before_action :authenticate_admin!
  layout "admin-bar"

  def index
    @user = current_user
    # Policy_scope  utilisée pour appliquer la politique de portée (policy scoping) aux collections d'enregistrements
    # policy_scope(Article) applique la politique de portée à la collection d'articles,
    # en fonction des autorisations définies dans votre politique ArticlePolicy
    @articles = policy_scope(Article).order('created_at DESC')
    @categories = policy_scope(Category)
    authorize @articles
    add_breadcrumb('Dashboard', admin_root_path)
    add_breadcrumb('Tous les Articles', admin_articles_path)
  end

  def mes_articles
    # @articles = current_user.articles.order('created_at DESC')
    @pagy, @articles = pagy(current_user.articles.order('created_at DESC'))
    add_breadcrumb('Dashboard', admin_root_path)
    add_breadcrumb('Mes articles', admin_mes_articles_path)
  end

  # Méthode pour afficher tous les articles pour les admins
  def tous_les_articles
    if current_user.admin?
      @pagy, @articles = pagy(Article.order('created_at DESC'))
      add_breadcrumb('Dashboard', admin_root_path)
      add_breadcrumb('Tous les Articles', admin_tous_les_articles_path)
    else
      redirect_to admin_root_path, alert: "Vous n'êtes pas autorisé à accéder à cette page."
    end
  end

  def new
    @user = current_user
    @article = Article.new
    if current_user.cse?
      @categories = policy_scope(Category).where(nom: 'infos CSE') # Assurez-vous que 'CSE' est le nom correct de votre catégorie
    elsif current_user.rh?
      @categories = policy_scope(Category).where.not(nom: 'infos CSE') # Assurez-vous que 'CSE' est le nom correct de votre catégorie
    else
      @categories = policy_scope(Category)
    end

    # @categories = policy_scope(Category)
    authorize @article
    add_breadcrumb('Dashboard', admin_root_path)
    add_breadcrumb('Ecrire un article', new_admin_article_path)
  end

  def create
    @user = current_user
    @article = Article.new(params_article)
    @article.user = current_user # Pour éviter l'erreur l'user n'existe pas
    authorize @article # Vérifie l'autorisation via Pundit
    if @article.save
      send_new_article_email
      redirect_to admin_article_path(@article), notice: 'Article créé!'
      # redirect_to url_for([:admin, @article]), notice: 'Article créé!'
    else
      flash.now[:alert] = "Impossible de créer l'article."
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @article = Article.find(params[:id])
    authorize @article
    add_breadcrumb('Dashboard', admin_root_path)
    add_breadcrumb(@article.title, admin_article_path(@article))
  end

  def edit
    add_breadcrumb('Dashboard', admin_root_path)
    add_breadcrumb(@article.title, edit_admin_article_path(@article))
  end

  def update
    # Début d'une transaction pour s'assurer que toutes les opérations sont atomiques
    ActiveRecord::Base.transaction do
      # Mise à jour de l'article avec les nouveaux attributs à l'exception des pièces jointes
      if @article.update(params_article.except(:documents, :existing_document_ids))
        # Gestion des documents existants pour la suppression
        if params[:article][:existing_document_ids].present?
          params[:article][:existing_document_ids].reject(&:blank?).each do |attachment_id|
            @article.documents.find(attachment_id).purge_later
          end
        end

        # Ajout des nouveaux documents si présents
        if params[:article][:documents].present?
          @article.documents.attach(params[:article][:documents])
        end

        redirect_to admin_mes_articles_path, notice: 'Article mis à jour avec succès.'
        # Si la transaction est réussie, elle sera automatiquement commitée à ce stade.
      else
        raise ActiveRecord::Rollback, "Article n'a pas pu être mis à jour"
      end
    end
  rescue ActiveRecord::Rollback => exception
    # Si une exception ActiveRecord::Rollback est levée, affiche les erreurs
    render :edit, alert: "Impossible de mettre à jour l'article: #{exception.message}"
  end

  def destroy
    @article.destroy
    redirect_to  admin_mes_articles_path, notice: 'L\'article a bien été supprimé.'
  end

  private

  def set_article
    @article = Article.find(params[:id])
    authorize @article
    if current_user.cse?
      @categories = policy_scope(Category).where(nom: 'infos CSE')
    elsif current_user.rh?
      @categories = policy_scope(Category).where.not(nom: 'infos CSE')
    else
      @categories = policy_scope(Category)
    end
  end

  def params_article
    params.require(:article).permit(:title, :rich_body, :category_id, images: [], documents: [])
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

  def send_new_article_email
    User.find_each do |user|
      ArticleMailer.new_article_email(@article, user).deliver_now
    end
  end

end
