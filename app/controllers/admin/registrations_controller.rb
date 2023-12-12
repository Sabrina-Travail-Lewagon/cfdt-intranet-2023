class Admin::RegistrationsController < Devise::RegistrationsController
  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]  # Assurez-vous que :user correspond à votre modèle Devise
  end
  def edit
    super
  end

  def update
    super
  end
end
