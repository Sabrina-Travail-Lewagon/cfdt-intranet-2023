class UserPolicy < ApplicationPolicy
  def access_dashboard?
    user.admin? || user.rh? || user.cse?
  end

  def index?
    admin_or_rh?
  end

  def create?
    admin_or_rh?
  end

  def show?
    admin_or_rh?
  end

  def update?
    admin_or_rh?
  end

  def destroy?
    admin_or_rh?
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
