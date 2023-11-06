class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_article

  def create
    @comment = @article.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
      redirect_to @article, notice: 'Commentaire ajouté avec succés.'
    else
      @comments = @article.comments.reload
      render 'articles/show'
    end
  end

  def destroy
    @comment = @article.comments.find(params[:id])
    authorize @comment
    @comment.destroy
    redirect_to @article, notice: 'Commentaire supprimé.'
  end

  private

  def set_article
    @article = Article.find(params[:article_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
