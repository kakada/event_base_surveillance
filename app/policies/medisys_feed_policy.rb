# frozen_string_literal: true

class MedisysFeedPolicy < ApplicationPolicy
  def index?
    true
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
