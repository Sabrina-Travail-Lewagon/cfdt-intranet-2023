class LikePolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
  # Tout utilisateur connecté peut créer un like
  def create?
    user.present?
  end

  # Seul l'utilisateur qui a créé le like ou un utilisateur avec un rôle admin ou RH peut le supprimer
  def destroy?
    record.user == user || user.admin? || user.rh?
  end
end
