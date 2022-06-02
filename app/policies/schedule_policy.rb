# frozen_string_literal: true

class SchedulePolicy < ApplicationPolicy
  def index?
    user.program_admin?
  end

  def create?
    user.program_admin?
  end

  def destroy?
    create?
  end
end
