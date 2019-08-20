class ApiKeyPolicy < ApplicationPolicy
  def index?
    user.system_admin? || user.program_admin?
  end

  def create?
    user.program_admin?
  end

  def update?
    return false unless user.program_admin?

    record.program_id == user.program_id
  end

  def destroy?
    update?
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
