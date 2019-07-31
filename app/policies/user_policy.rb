class UserPolicy < ApplicationPolicy
  def create?
    user.system_admin? || user.program_admin?
  end

  def destroy?
    if (record.id == user.id)
      return false
    end

    if user.system_admin?
      true
    elsif user.program_admin? and not record.system_admin?
      true
    else
      false
    end
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
      if user.system_admin?
        scope.all
      else
        scope.where(program_id: user.program_id)
      end
    end
  end
end
