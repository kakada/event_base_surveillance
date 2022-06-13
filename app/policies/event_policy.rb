# frozen_string_literal: true

class EventPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    return true if user.system_admin?
    return false unless (record.program_id == user.program_id) || record.shared_with?(user.program_id)

    user.program_admin? || user.province_code == "all" || user.province_code == record.location_code[0..1]
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
      elsif user.program_admin? || user.province_code == "all"
        program_event_and_shared_events
      else
        program_event_and_shared_events.where("location_code LIKE ?", "#{user.province_code}%")
      end
    end

    private
      def program_event_and_shared_events
        scope.left_joins(:event_shareds).where("events.program_id = ? OR event_shareds.program_id = ?", user.program_id, user.program_id)
      end
  end
end
