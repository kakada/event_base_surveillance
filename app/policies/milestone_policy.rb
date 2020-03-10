# frozen_string_literal: true

class MilestonePolicy < ApplicationPolicy
  def index?
    user.program_admin?
  end

  def create?
    user.program_admin?
  end

  def delete?
    user.program_admin? && !record.root?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
