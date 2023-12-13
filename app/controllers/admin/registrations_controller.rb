class Admin::RegistrationsController < Devise::RegistrationsController
  before_action :restrict_access_on_mobile
  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]  # Assurez-vous que :user correspond à votre modèle Devise
  end
  def edit
    super
  end

  def update
    super
  end
  private
  # Restriction de l'accès sur mobile
  def restrict_access_on_mobile
    redirect_to root_path, alert: "L'accès admin n'est pas disponible sur les téléphones" if device_type == :mobile
  end
end
