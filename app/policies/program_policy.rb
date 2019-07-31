class ProgramPolicy < ApplicationPolicy
  def create?
    user.system_admin?
  end

  class Scope < Scope
    def resolve
      if user.system_admin?
        scope.all
      else
        scope.where(id: user.program_id)
      end
    end
  end
end
