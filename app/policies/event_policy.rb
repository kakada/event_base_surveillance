# frozen_string_literal: true

class EventPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    user.system_admin? || user.program_admin? || user.province_code == 'all' || user.province_code == record.location_code
  end

  def create?
    user.program_admin? || user.staff?
  end

  def update?
    return false if record.close? || !(user.program_admin? || user.staff?)

    record.program_id == user.program_id
  end

  def destroy?
    false
  end

  class Scope < Scope
    def resolve
      if user.system_admin?
        scope.all
      elsif user.program_admin? || user.province_code == 'all'
        scope.joins(:event_type).where('events.program_id = ? or event_types.shared = ?', user.program_id, true)
      else
        scope.joins(:field_values)
          .where(program_id: user.program_id)
          .where('field_values.field_code = ? and field_values.value = ?', 'province_id', user.province_code)
      end
    end
  end
end
