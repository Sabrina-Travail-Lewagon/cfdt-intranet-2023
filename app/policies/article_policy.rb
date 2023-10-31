class ArticlePolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.all
    end
  end

  def index?
    true
  end

  def show?
    true
  end

  def create?
    allowed_roles?
  end

  def update?
    allowed_roles?
  end

  def destroy?
    allowed_roles?
  end

  private
  def allowed_roles?
    # user && permet de vérifier que l'user est connecté, et Autorise admin ou rh à voir les catégorie
    user && (user.admin? || user.rh? || user.cse?)
  end
end
