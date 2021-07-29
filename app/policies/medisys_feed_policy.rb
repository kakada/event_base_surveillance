# frozen_string_literal: true

class MedisysFeedPolicy < ApplicationPolicy
  def index?
    true
  end

  class Scope < Scope
    def resolve
      if user.system_admin?
        scope.all
      else
        scope.where(program_id: user.program_id)
      end
    end
  end
end
