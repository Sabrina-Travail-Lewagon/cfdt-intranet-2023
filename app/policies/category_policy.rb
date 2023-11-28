class CategoryPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.all
    end
  end
  def index?
    allowed_roles?
  end
  def show?
    allowed_roles?
  end
  def create?
    admin_or_rh?
  end
  def update?
    admin_or_rh?
  end
  def destroy?
    admin_or_rh?
  end

  def allowed_roles?
    # user && permet de vérifier que l'user est connecté, et Autorise admin ou rh à voir les catégorie
    user && (user.admin? || user.rh?)
  end
  def admin_or_rh?
    # Vérification que user existe avant avec user :
    user.admin? || user.rh?
  end
end
