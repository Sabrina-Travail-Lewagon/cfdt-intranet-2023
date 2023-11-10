class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @article = Article.find(params[:article_id])
    @rating = @article.ratings.new(rating_params)
    @rating.user = current_user

    if @rating.save
      redirect_to @article, notice: 'J\'aime créé avec succés.'
    else
      redirect_to @article, alert: 'Il y a eu une erreur.'
    end
  end

  def destroy
  end

  private

  def rating_params
    params.require(:rating).permit(:score)
  end
end
