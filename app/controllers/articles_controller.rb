class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :destroy, :update]
  before_action :authenticate_user!
  after_action :verify_authorized
  layout "standard"

  def index
    @user = current_user
    @categories = policy_scope(Category)
    add_breadcrumb('Articles', articles_path)
    scope = policy_scope(Article) # On définit une base de scope pour tous les cas.
    if params[:category_id]
      category = Category.find(params[:category_id]) # Définition de la variable category
      add_breadcrumb(category.nom, articles_path(category_id: category.id)) # Ajout du breadcrumb pour la catégorie
      @pagy, @articles = pagy(scope.where(category_id: category.id).order('created_at DESC'))
      #Ajout de la recherche
    elsif params[:search].present?
      @pagy, @articles = pagy(scope.search_by_title_and_content(params[:search])) # Recherche filtrée
    else
      @pagy, @articles = pagy(scope.order('created_at DESC')) # Liste de tous les articles
    end
    authorize @articles
  end

  def new
    @user = current_user
    @categories = policy_scope(Category)
    @article = Article.new
    authorize @article
    add_breadcrumb('Ecrire un article', new_article_path)
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
    add_breadcrumb(@article.category.nom, articles_path(category_id: @article.category.id)) # Ajout du breadcrumb pour la catégorie
    add_breadcrumb(@article.title, article_path(@article))
    @article.increment!(:views_count)
    @comments = @article.comments.order('created_at DESC')
    # @comment = Comment.new  # Initialisation d'une nouvelle instance de commentaire pour le formulaire
    # Initialisation d'une nouvelle instance de commentaire pour le formulaire
    @comment = Comment.new unless flash[:comment_errors] # Prise en charge des erreurs
  end

  def edit
    add_breadcrumb(@article.title, edit_article_path(@article))
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
    @categories = policy_scope(Category)
  end

  def params_article
    params.require(:article).permit(:title, :rich_body, :category_id, images: [], documents: [])
  end

end
