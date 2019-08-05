class EventPolicy < ApplicationPolicy
  def index?
    true
  end

  def create?
    user.program_admin? || user.staff?
  end

  def update?
    return false unless user.program_admin? || user.staff?

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
        scope.joins(:event_type).where('program_id = ? or event_types.shared = ?', user.program_id, true)
      end
    end
  end
end
