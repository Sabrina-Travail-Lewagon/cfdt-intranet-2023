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
    add_breadcrumb('Dashboard', admin_root_path)
    add_breadcrumb('Tous les Articles', admin_articles_path)
  end

  def mes_articles
    @articles = current_user.articles.order('created_at DESC')
    add_breadcrumb('Dashboard', admin_root_path)
    add_breadcrumb('Mes articles', admin_mes_articles_path)
  end

  def new
    @user = current_user
    @article = Article.new
    @categories = policy_scope(Category)
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
    if @article.update(params_article)
      redirect_to  admin_mes_articles_path(@article), notice: 'Article mis à jour.'
    else
      redirect_to admin_path, :alert => "Impossible de mettre à jour l'article."
    end
  end

  def destroy
    @article.destroy
    redirect_to  admin_mes_articles_path, notice: 'L\'article a bien été supprimé.'
  end

  private

  def set_article
    @article = Article.find(params[:id])
    authorize @article
    @categories = policy_scope(Category)
  end

  def params_article
    params.require(:article).permit(:title, :rich_body, :category_id, images: [])
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
