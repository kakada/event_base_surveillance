# frozen_string_literal: true

class MedisysFeedPolicy < ApplicationPolicy
  def index?
    user.system_admin? || user.program_admin? || user.staff?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
