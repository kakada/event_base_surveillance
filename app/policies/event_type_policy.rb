class EventTypePolicy < ApplicationPolicy
  def index?
    user.system_admin? || user.program_admin?
  end

  def create?
    user.program_admin?
  end

  def destroy?
    create?
  end

  class Scope < Scope
    def resolve
      if user.system_admin?
        scope.all
      else
        scope.joins(:user => :program).where('programs.id = ?', user.program_id)
      end
    end
  end
end
