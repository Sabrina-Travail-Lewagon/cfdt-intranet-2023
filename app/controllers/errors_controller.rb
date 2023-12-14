class ErrorsController < ActionController::Base
  def internal_server_error
    # ON récupère le numéro de l'erreur pour le title
    @error_code = 500
    render status: 500
  end

  def not_found
    @error_code = 404
    render status: 404
  end
end
