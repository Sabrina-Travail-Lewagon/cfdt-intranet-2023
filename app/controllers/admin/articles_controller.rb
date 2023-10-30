class Admin::ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :destroy, :update]
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
  end

  def mes_articles
    @articles = current_user.articles.order('created_at DESC')
  end

  def new
    @user = current_user
    @article = Article.new
    @categories = policy_scope(Category)
    authorize @article
  end

  def create
    @user = current_user
    @article = Article.new(params_article)
    @article.user = current_user # Pour éviter l'erreur l'user n'existe pas
    authorize @article # Vérifie l'autorisation via Pundit
    if @article.save
      redirect_to dashboard_articles_path(@article), notice: 'Article créé!'
    else
      flash.now[:alert] = "Impossible de créer l'article."
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @article = Article.find(params[:id])
    authorize @article
  end

  def edit
    @article = Article.find(params[:id])
    authorize @article
  end

  def update
    if @article.update(params_article)
      redirect_to dashboard_article_path(@article), notice: 'Article mis à jour.'
    else
      redirect_to articles_path, :alert => "Impossible de mettre à jour l'article."
    end
  end

  def destroy
    @article.destroy
    redirect_to dashboard_articles_path, notice: 'Article a bien été supprimé.'
  end

  private

  def set_article
    @article = Article.find(params[:id])
    authorize @article
  end

  def params_article
    params.require(:article).permit(:title, :rich_body, :category_id, images: [])
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
end
