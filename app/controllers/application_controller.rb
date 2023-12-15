class ApplicationController < ActionController::Base
  include Pagy::Backend
  before_action :authenticate_user!
  helper_method :device_type

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_breadcrumbs

  include Pundit::Authorization

  # Pundit: allow-list approach
  after_action :verify_authorized, except: [:index, :faq], unless: :skip_pundit?
  after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?

  # Rescue from standard HTTP error codes
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # Gestion des erreurs spécifiques
  rescue_from ActionController::RoutingError, with: :route_not_found
  rescue_from ActionController::UnknownFormat, with: :bad_request
  rescue_from ActionController::InvalidCrossOriginRequest, with: :bad_request
  rescue_from ActionController::InvalidAuthenticityToken, with: :bad_request
  rescue_from AbstractController::ActionNotFound, with: :route_not_found
  rescue_from ActionView::MissingTemplate, with: :bad_request
  # Personnalisation de l'erreur, quand une catégorie recherchée n'existe pas
  rescue_from ActiveRecord::RecordNotFound, with: :resource_not_found
  rescue_from ActiveRecord::RecordNotSaved, with: :not_acceptable
  rescue_from AbstractController::DoubleRenderError, with: :bad_request
  # Rescue from standard HTTP error codes
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def skip_pundit?
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)/
  end

  # Methode pour gérer l'exéception 'Pundit::NotAuthorizedError'
  def user_not_authorized
    flash[:alert] = "Vous n'êtes pas autorisé à accéder à cette ressource"
    redirect_to(request.referrer || root_path)
  end

  def bad_request
    flash[:alert] = "Requête invalide."
    redirect_to bad_request_path # Assurez-vous que cette route existe
  end

  def not_acceptable
    flash[:alert] = "Requête non acceptable."
    redirect_to unprocessable_entity_path # Assurez-vous que cette route existe
  end

  def resource_not_found
    flash[:alert] = "La ressource demandée n'a pas été trouvée."
    redirect_to not_found_path # Assurez-vous que cette route existe
  end

  def RecordNotFound
    flash[:alert] = "La catégorie demandée n'a pas été trouvée."
    redirect_to categories_path
  end

  def route_not_found
    flash[:alert] = "La route demandée n'a pas été trouvée."
    redirect_to not_found_path # Assurez-vous que cette route existe
  end

  def configure_permitted_parameters
    # For additional fields in app/views/devise/registrations/new.html.erb
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :role, :photo])
    # For additional in app/views/devise/registrations/edit.html.erb
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :role, :photo])
  end

  def set_breadcrumbs
    @breadcrumbs = [
      { name: 'Accueil', path: root_path }
    ]
  end

  def add_breadcrumb(name, path)
    @breadcrumbs << { name: name, path: path }
  end

  def device_type
    if browser.device.mobile?
      :mobile
    else
      :desktop_or_tablet
    end
  end
end
