# frozen_string_literal: true

class NotificationMailer < ApplicationMailer
  def notify(emails, body_message)
    @body_message = body_message
    mail(to: emails, subject: 'EBS Notification')
  end
end
