class EventPolicy < ApplicationPolicy
  def index?
    true
  end

  def create?
    user.program_admin? || user.staff?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
