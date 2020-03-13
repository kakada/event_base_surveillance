# frozen_string_literal: true

class TelegramWorker
  include Sidekiq::Worker

  def perform(id, class_name)
    return unless %(Event EventMilestone).include? class_name

    klass = class_name.constantize
    event_or_em = klass.where("#{klass.primary_key} = ?", id).first

    return if event_or_em.nil? || event_or_em.milestone.message.try(:telegram_notification).nil?

    event_or_em.milestone.message.telegram_notification.notify_groups(event_or_em.telegram_message)
  end
end
