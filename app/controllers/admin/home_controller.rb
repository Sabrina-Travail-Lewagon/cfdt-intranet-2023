class Admin::HomeController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_policy_scoped, only: [:index]

  def index
    @articles = policy_scope(Article).order('created_at DESC').limit(5)
    @categories = policy_scope(Category)
    authorize @articles
  end
end
