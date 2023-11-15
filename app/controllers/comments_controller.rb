class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_article
  before_action :set_comment, only: [:update, :destroy]
  layout "standard"

  def create
    @comment = @article.comments.build(comment_params)
    @comment.user = current_user
    authorize @comment
    if @comment.save
      flash[:notice] = 'Commentaire ajouté avec succès.'
      redirect_to @article, notice: 'Commentaire ajouté avec succés.'
    else
      @comments = @article.comments.reload
      @categories = policy_scope(Category)
      render 'articles/show', status: :unprocessable_entity
    end
  end

  def update
    authorize @comment
    if @comment.update(comment_params)
      # Traiter la réussite de la mise à jour
      redirect_to @article, notice: 'Commentaire mis à jour avec succès.'
    else
      # Gérer l'échec de la mise à jour, par exemple en ré-affichant le formulaire
      render 'articles/show'
    end
  end

  def destroy
    authorize @comment
    @comment.destroy
    redirect_to @article, notice: 'Commentaire supprimé.'
  end

  private

  def set_article
    @article = Article.find(params[:article_id])
  end

  def set_comment
    @comment = @article.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
