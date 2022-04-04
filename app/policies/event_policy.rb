# frozen_string_literal: true

class EventPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    return true if user.system_admin?
    return false unless (record.program_id == user.program_id) || record.shared?

    user.program_admin? || user.province_code == 'all' || user.province_code == record.location_code[0..1]
  end

  def create?
    user.staff?
  end

  def update?
    return false if record.unlockable? || !user.staff?

    record.program_id == user.program_id
  end

  def destroy?
    user.program_admin?
  end

  def download?
    user.system_admin? || user.program_admin? || user.staff?
  end

  def unlock?
    user.program_admin? && record.unlockable?
  end

  class Scope < Scope
    def resolve
      if user.system_admin?
        scope.all
      elsif user.program_admin? || user.province_code == 'all'
        scope.joins(:event_type).where('events.program_id = ? or event_types.shared = ?', user.program_id, true)
      else
        scope.joins(:event_type)
             .where('events.program_id = ? or event_types.shared = ?', user.program_id, true)
             .where('location_code LIKE ?', "#{user.province_code}%")
      end
    end
  end
end
