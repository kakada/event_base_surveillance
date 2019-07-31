class UserPolicy < ApplicationPolicy
  def create?
    user.system_admin? || user.program_admin?
  end

  def destroy?
    create?
  end

  def roles
    if user.system_admin?
      User::ROLES
    else
      User.roles.keys.reject { |r| r == 'system_admin' }.map { |r| [r.titlecase, r] }
    end
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
