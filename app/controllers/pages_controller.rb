class PagesController < ApplicationController
  before_action :authenticate_user!, only: [ :home ]

  def home
    ordered_ids = [1,3,4,5,6,7,8,2,9,10] # Les IDs dans l'ordre souhaité
    @categories = Category.find(ordered_ids)
    @articles = Article.order('created_at DESC').limit(5)
  end
end
