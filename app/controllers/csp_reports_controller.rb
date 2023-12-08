# app/controllers/csp_reports_controller.rb
class CspReportsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create]
  # Sauter la vérification de l'authenticité du token CSRF
  skip_before_action :verify_authenticity_token, only: [:create]
  # Pour passer la vérification Pundit :
  skip_after_action :verify_authorized, only: [:create]

  def create
    # Vous pouvez enregistrer la violation de la CSP dans votre système de logging, dans une base de données, envoyer un e-mail, etc.
    # Logique pour gérer le rapport, par exemple:
    # Rails.logger.info "CSP Violation: #{request.body.read}"
    # Lire le rapport JSON depuis le corps de la requête
    report_json = request.body.read

    # Parser le rapport JSON en un objet Ruby (hash)
    report = JSON.parse(report_json)

    # Logger le rapport pour un examen ultérieur
    logger.info "CSP Violation: #{report}"
    # Assurez-vous de ne pas répondre avec un body pour ne pas générer une autre violation CSP
    head :no_content
  end
end
