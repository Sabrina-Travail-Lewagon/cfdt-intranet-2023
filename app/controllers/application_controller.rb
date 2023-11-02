class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_breadcrumbs

  include Pundit::Authorization

  # Pundit: allow-list approach
  after_action :verify_authorized, except: :index, unless: :skip_pundit?
  after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?

  def configure_permitted_parameters
    # For additional fields in app/views/devise/registrations/new.html.erb
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :role, :photo])

    # For additional in app/views/devise/registrations/edit.html.erb
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :role, :photo])
  end

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # Personnalisation de l'erreur, quand une catégorie recherchée n'existe pas
  rescue_from ActiveRecord::RecordNotFound, with: :RecordNotFound # Appelle la methode RecordNotFound

  private

  def skip_pundit?
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)/
  end

  # Methode pour gérer l'exéception 'Pundit::NotAuthorizedError'
  def user_not_authorized
    flash[:alert] = "Vous n'êtes pas autorisé à accéder à cette ressource"
    redirect_to(request.referrer || root_path)
  end

  def RecordNotFound
    flash[:alert] = "La catégorie demandée n'a pas été trouvée."
    redirect_to categories_path
  end

  def set_breadcrumbs
    @breadcrumbs = []
  end

  def add_breadcrumb(name, path)
    @breadcrumbs << { name: name, path: path }
  end

end
