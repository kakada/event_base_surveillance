class EventPolicy < ApplicationPolicy
  def index?
    true
  end

  def create?
    user.program_admin? || user.staff?
  end

  class Scope < Scope
    def resolve
      if user.system_admin?
        scope.all
      else
        scope.joins(:creator => :program).where('programs.id = ?', user.program_id)
      end
    end
  end
end
