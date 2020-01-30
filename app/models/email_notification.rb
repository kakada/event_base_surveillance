# frozen_string_literal: true

class EmailNotification < ApplicationRecord
  belongs_to :message, optional: true

  def notity(message, body_message)
    return unless message.email_notification.emails.present?

    @body_message = body_message
    mail(to: emails, subject: 'EBS Notification')
  end
end
