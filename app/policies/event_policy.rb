# frozen_string_literal: true

class EventPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    user.system_admin? || user.program_admin? || user.province_code == 'all' || user.province_code == record.location_code[0..1]
  end

  def create?
    user.staff?
  end

  def update?
    return false if (record.close? && record.lockable_at.nil?) || !user.staff?

    record.program_id == user.program_id
  end

  def destroy?
    user.program_admin?
  end

  def download?
    user.system_admin? || user.program_admin? || user.staff?
  end

  def unlock?
    user.program_admin? && record.close? && record.lockable_at.nil?
  end

  class Scope < Scope
    def resolve
      if user.system_admin?
        scope.all
      elsif user.program_admin? || user.province_code == 'all'
        scope.joins(:event_type).where('events.program_id = ? or event_types.shared = ?', user.program_id, true)
      else
        scope.where(program_id: user.program_id)
             .where('location_code LIKE ?', "#{user.province_code}%")
      end
    end
  end
end
