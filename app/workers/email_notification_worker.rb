# frozen_string_literal: true

class EmailNotificationWorker
  include Sidekiq::Worker

  def perform(id, class_name)
    klass = class_name.constantize
    condition = {}
    condition[klass.primary_key] = id
    obj = klass.find_by(condition)

    return if obj.nil? || obj.milestone.message.try(:email_notification).nil?

    NotificationMailer.notify(obj.milestone.message.email_notification.emails.join(','), obj.telegram_message).deliver_now
  end
end

