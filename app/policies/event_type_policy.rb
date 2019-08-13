# frozen_string_literal: true

class EventTypePolicy < ApplicationPolicy
  def index?
    user.system_admin? || user.program_admin?
  end

  def create?
    user.program_admin?
  end

  def update?
    user.program_admin? && record.events.blank?
  end

  def destroy?
    update?
  end

  class Scope < Scope
    def resolve
      if user.system_admin?
        scope.all
      else
        scope.joins(user: :program).where('programs.id = ?', user.program_id)
      end
    end
  end
end