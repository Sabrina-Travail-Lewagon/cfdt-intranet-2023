class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_article

  def create
    like = @article.likes.new(user: current_user)
    if like.save
      flash[:notice] = 'Vous avez liké cet article.'
    else
      flash[:alert] = 'Vous ne pouvez pas dé-liker cet article.'
    end
    redirect_to @article
  end

  def destroy
    like = @article.likes.find_by(user_id: current_user.id)
    if like
      like.destroy
      flash[:notice] = 'Vous avez unliké cet article.'
    else
      flash[:alert] = 'Vous ne pouvez pas déliké un article que vous n\'avez pas liké'
    end
    redirect_to @article
  end

  private

  def set_article
    @article = Article.find(params[:article_id])
  end
end
