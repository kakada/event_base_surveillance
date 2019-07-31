class ProgramPolicy < ApplicationPolicy
  def create?
    user.system_admin?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
