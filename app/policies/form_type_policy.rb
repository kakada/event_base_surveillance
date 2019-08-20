# frozen_string_literal: true

class FormTypePolicy < ApplicationPolicy
  def create?
    user.program_admin?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
