# frozen_string_literal: true

class NotificationMailer < ApplicationMailer
  default from: ENV['SETTINGS__SMTP__DEFAULT_FROM']

  def notify(emails, body_message)
    @body_message = body_message
    mail(to: emails, subject: 'EBS Notification')
  end
end
