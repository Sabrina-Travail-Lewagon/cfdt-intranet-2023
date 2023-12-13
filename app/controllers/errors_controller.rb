class ErrorsController < ApplicationController
  skip_after_action :verify_authorized, :verify_policy_scoped

  def bad_request
    render template: 'errors/bad_request', status: :bad_request
  end

  def resource_not_found
    render template: 'errors/resource_not_found', status: :not_found
  end

  def not_acceptable
    render template: 'errors/not_acceptable', status: :not_acceptable
  end

  def not_authorized
    render template: 'errors/not_authorized', status: :unprocessable_entity
  end

  def internal_server_error
    render template: 'errors/internal_server_error', status: :internal_server_error
  end

  def service_unavailable
    render template: 'errors/service_unavailable', status: :service_unavailable
  end
end
