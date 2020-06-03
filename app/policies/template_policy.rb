# frozen_string_literal: true

class TemplatePolicy < ApplicationPolicy
  def index?
    user.program_admin?
  end

  def show?
    user.program_admin?
  end

  def create?
    user.program_admin?
  end

  def update?
    create?
  end

  def destroy?
    create?
  end

  class Scope < Scope
    def resolve
      if user.system_admin?
        scope.all
      elsif user.program_admin? || user.staff?
        scope.where(program_id: user.program_id)
      end
    end
  end
end
