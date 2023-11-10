class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_article, only: [:create, :destroy]

  def create
    @like = @article.likes.new(user: current_user)
    authorize @like
    if @like.save
      flash[:notice] = 'Vous avez liké cet article.'
    else
      # Le message ici devrait refléter l'échec de la création du like, pas le "dé-like"
      flash[:alert] = 'Un problème est survenu, vous ne pouvez pas liker cet article.'
    end
    redirect_to articles_path
  end

  def destroy
    @like = @article.likes.find_by(user_id: current_user.id)
    authorize @like
    if @like.destroy
      flash[:notice] = 'Vous avez retiré votre like de cet article.'
    else
      # Ce message s'affiche si l'utilisateur essaie de retirer un like qui n'existe pas ou s'il y a une erreur de suppression
      flash[:alert] = 'Vous ne pouvez pas retirer un like d\'un article que vous n\'avez pas liké ou une erreur est survenue.'
    end
    redirect_to articles_path
  end

  private

  def set_article
    @article = Article.find(params[:article_id])
  end
end
