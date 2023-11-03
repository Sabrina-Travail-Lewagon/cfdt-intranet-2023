class Admin::ApplicationController < ApplicationController
  before_action :authenticate_user!
  include Pundit::Authorization
  before_action :authorize_admin!
  before_action :set_dashboard_breadcrumbs

  private
  def authorize_admin!
    puts "Current user role: #{current_user.role}" # Affiche le rôle de l'utilisateur actuel
    unless current_user.admin? || current_user.rh? || current_user.cse? || current_user.user?
      redirect_to root_path, alert: "Vous n'avez pas accès à cette section."
    end
  end
  def set_dashboard_breadcrumbs
    @breadcrumbs = [
      { name: 'Dashboard', path: admin_root_path }
    ]
  end
end
