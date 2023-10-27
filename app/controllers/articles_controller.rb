class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :destroy, :update]
  before_action :authenticate_user!
  after_action :verify_authorized

  def index
    @user = current_user
    @categories = policy_scope(Category)
    if params[:category_id]
      category = Category.find(params[:category_id]) # Définition de la variable category
      @categories = policy_scope(Category)
      @articles = policy_scope(Article).where(category_id: category.id).order('created_at DESC')
    else
      # Policy_scope  utilisée pour appliquer la politique de portée (policy scoping) aux collections d'enregistrements
       # policy_scope(Article) applique la politique de portée à la collection d'articles,
      # en fonction des autorisations définies dans votre politique ArticlePolicy
      @articles = policy_scope(Article).order('created_at DESC')
    end
    authorize @articles
  end

  def new
    @user = current_user
    @article = Article.new
    authorize @article
  end

  def create
    @user = current_user
    @article = Article.new(params_article)
    @article.user = current_user # Pour éviter l'erreur l'user n'existe pas
    authorize @article # Vérifie l'autorisation via Pundit
    if @article.save
      redirect_to articles_path(@article), notice: 'Article créé!'
    else
      console
      flash.now[:alert] = "Impossible de créer l'article."
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    if @article.update(params_article)
      redirect_to articles_path, :notice => "Article mis à jour."
    else
      redirect_to articles_path, :alert => "Impossible de mettre à jour l'article."
    end
  end

  def destroy
    @article.destroy
    redirect_to articles_path, notice: 'Article a bien été supprimé.'
  end

  private

  def set_article
    @article = Article.find(params[:id])
    @user = current_user # Pour que le header puisse s'afficher avec le login
    authorize @article
  end

  def params_article
    params.require(:article).permit(:title, :rich_body, :category_id, images: [])
  end

end
