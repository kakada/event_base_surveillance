# frozen_string_literal: true

class UnlockEventJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Event.where("DATE(lockable_at) <= ?", Date.today).update_all(lockable_at: nil)
  end
end
