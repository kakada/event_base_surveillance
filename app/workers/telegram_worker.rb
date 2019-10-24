# frozen_string_literal: true

class TelegramWorker
  include Sidekiq::Worker

  def perform(id, class_name)
    klass = class_name.constantize
    condition = {}
    condition[klass.primary_key] = id
    obj = klass.find_by(condition)

    return if obj.nil? || obj.milestone.telegram.nil?

    obj.milestone.telegram.notify_groups(obj.telegram_message)
  end
end