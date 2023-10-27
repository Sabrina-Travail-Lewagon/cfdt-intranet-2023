class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
    @categories = Category.all
    @articles = Article.order('created_at DESC').limit(5)
  end
end
