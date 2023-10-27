class Admin::ApplicationController < ApplicationController
  before_action :authenticate_user!
  include Pundit::Authorization
  before_action :authorize_admin!

  private
  def authorize_admin!
    # Votre logique pour autoriser uniquement les admins et rh
    redirect_to root_path, alert: "Vous n'avez pas accès à cette section." unless current_user.admin? || current_user.rh?
  end
end
