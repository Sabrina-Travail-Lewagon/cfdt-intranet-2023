class UserPolicy < ApplicationPolicy
  def access_dashboard?
    user.admin? || user.rh? || user.cse? || user.user?
  end

  # Seuls les administrateurs et les RH peuvent voir la liste des utilisateurs
  def index?
    admin_or_rh?
  end

  # Seuls les administrateurs et les RH peuvent créer un utilisateur
  def create?
    admin_or_rh?
  end

  # Seuls les administrateurs et les RH peuvent voir les détails d'un utilisateur
  def show?
    admin_or_rh?
  end

  # Tout le monde peut mettre à jour son propre compte (pour changer le mot de passe par exemple)
  # Mais si vous voulez limiter la mise à jour à certains champs pour les utilisateurs non admin/RH,
  # cela devra être géré dans le contrôleur.
  def update?
    user == record || admin_or_rh?
  end

  # Seuls les administrateurs et les RH peuvent supprimer un utilisateur
  def destroy?
    admin_or_rh?
  end

  # CSE a accès à écrire un article
  def write_article?
    user.cse? || user.admin? || user.rh?
  end

  # CSE a accès à voir ses articles
  def view_articles?
    user.cse? || user.admin? || user.rh?
  end

  # admin a accès à gestion des articles
  def gestion_article?
    user.admin?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end

  private

  def admin_or_rh?
    # Vérification que user existe avant avec user :
    user && (user.admin? || user.rh?)
  end
end
