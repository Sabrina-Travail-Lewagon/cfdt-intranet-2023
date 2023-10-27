class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :destroy]
  before_action :authenticate_user!

  def index
    @user = current_user
    @articles = Article.all.order('created_at DESC')
  end

  def show
  end

  def edit
  end

  def destroy
  end

  private
  def set_article
    @article = Article.find(params[:id])
  end
end
