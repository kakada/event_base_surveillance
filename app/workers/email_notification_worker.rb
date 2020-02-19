# frozen_string_literal: true

class EmailNotificationWorker
  include Sidekiq::Worker

  def perform(id, class_name)
    klass = class_name.constantize
    condition = {}
    condition[klass.primary_key] = id
    event = klass.find_by(condition)

    return if event.nil? || event.milestone.message.try(:email_notification).nil?

    NotificationMailer.notify(event.milestone.message.email_notification.emails.join(','), event.telegram_message).deliver_now
  end
end
