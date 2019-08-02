class EventPolicy < ApplicationPolicy
  def index?
    true
  end

  def create?
    user.program_admin? || user.staff?
  end

  def update?
    user.id == record.creator.id
  end

  class Scope < Scope
    def resolve
      if user.system_admin?
        scope.all
      else
        scope.joins(:creator => :program).where('programs.id = ? or shared = ?', user.program_id, true)
      end
    end
  end
end
